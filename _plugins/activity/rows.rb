# frozen_string_literal: true

# Activity rows: the display rules for the Activity data in _data/activity/*.yml, as a
# pure module with no Jekyll or Time dependency. _plugins/activity_generator.rb runs it at
# build time and exposes the result to Liquid as site.data.activity_view; the generator's
# header comment documents every key and field. Tests: .github/scripts/test-activity.rb.
#
# It ports the display rules of the round-2 design handoff (buildRows, week, range,
# railRows, byWeek, byMonth and panelSummary), with the amendments and decisions recorded
# on QuantEcon/website#276:
# - a complete sort order that never depends on the order of files or entries;
# - one row per series per day: a lecture series or book that published twice becomes one
#   ordinary row, and a series' translations become one editions row;
# - a day's releases form one row, whose title lists each project once, after copies of
#   one release (the same url on the same day) merge into one;
# - a `book` type;
# - a stable row id (the merge key);
# - empty or nil data gives empty views.
#
# Dates are calendar days (UTC), given as Date objects or YYYY-MM-DD strings. They are
# compared as strings and never converted to Time: Jekyll sets TZ to the site's timezone
# (Australia/Sydney), and a Time would shift the day.
#
# Every value is a plain string, integer, boolean, nil, list or string-keyed hash, and no
# string is HTML-escaped: summaries and PR titles come from outside the site, so the
# templates escape every field.
require "date"

module ActivityRows
  # Raised for data the rows can't be built from. The message names the file and entry.
  class DataError < StandardError; end

  # The entry types, in their order within a day. A type's filter key (the rail and log
  # filters, and a row's data-type) is the type itself.
  TYPE_ORDER = %w[lectures book translation release].freeze
  # The visually hidden word before a row's title.
  TYPE_WORD = {
    "lectures" => "Lecture update:",
    "book" => "Book update:",
    "translation" => "Translation:",
    "release" => "Release:",
  }.freeze
  # The same word for an editions row or a release group.
  MERGED_TYPE_WORD = { "translation" => "Translations:", "release" => "Releases:" }.freeze

  RAIL_SIZE = 6 # rows per filter in the /news/ rail
  STRIP_SIZE = 3 # rows in the home strip

  SHORT_MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  MONTHS = %w[January February March April May June July August September October November
              December].freeze
  DAY = /\A\d{4}-\d{2}-\d{2}\z/
  # A translated edition's project is "<series name> (<language>)".
  SERIES = /\A(.*) \(([^)]+)\)\z/
  PULL_NUMBER = %r{/pull/(\d+)}

  Entry = Struct.new(:date, :type, :project, :url, :version, :summary, :changes, keyword_init: true)
  private_constant :Entry

  class << self
    # The whole view that the generator exposes as site.data.activity_view. `data` is what
    # Jekyll puts in site.data["activity"] (data file name => list of entries), a plain list
    # of entries, or nil. `source` names the data's directory in error messages.
    def view(data, source: nil)
      list = entries(data, source)
      rows = rows_from(list)
      first = list.map(&:date).min
      {
        "rows" => rows,
        "rail" => rail(rows),
        "months" => by_month(rows),
        "panel" => panel_from(list),
        "strip" => rows.first(STRIP_SIZE),
        "first_date" => first,
        "first_date_label" => first && long(first),
      }
    end

    # Every row, newest day first (buildRows).
    def build_rows(data)
      rows_from(entries(data, nil))
    end

    # The rail's rows for one filter: the latest 6 rows, or the latest 6 of one type
    # (railRows). `filter` is "all" or a type.
    def rail_rows(rows, filter = "all")
      list = filter == "all" ? rows : rows.select { |row| row["type"] == filter }
      list.first(RAIL_SIZE)
    end

    # The rail as rendered: week groups over the latest 6 rows of each type, each row once.
    # A row is flagged in_all when it is among the latest 6 overall (the All view), and a
    # group has_all when it holds such a row. The latest 6 overall are always among the
    # latest 6 of their own type, so filtering these rows by type or by in_all reproduces
    # every filter's rail.
    def rail(rows)
      newest = rail_rows(rows).map { |row| row["id"] }
      shown = TYPE_ORDER.flat_map { |type| rail_rows(rows, type) }.map { |row| row["id"] }
      flagged = rows.select { |row| shown.include?(row["id"]) }
                    .map { |row| row.merge("in_all" => newest.include?(row["id"])) }
      by_week(flagged).each { |group| group["has_all"] = group["rows"].any? { |row| row["in_all"] } }
    end

    # Groups rows, newest first, under Monday-to-Sunday week headings (byWeek).
    def by_week(rows)
      rows.each_with_object([]) do |row, groups|
        heading = week(row["date"])
        groups << heading.merge("rows" => []) unless groups.last && groups.last["start"] == heading["start"]
        groups.last["rows"] << row
      end
    end

    # Groups rows, newest first, into months and then days (byMonth). A month counts its
    # rows and, separately, the entries merged into them.
    def by_month(rows)
      rows.each_with_object([]) do |row, months|
        id = "activity-#{row['date'][0, 7]}"
        unless months.last && months.last["id"] == id
          months << { "id" => id, "label" => month_label(row["date"]), "row_count" => 0, "entry_count" => 0,
                      "days" => [] }
        end
        month = months.last
        unless month["days"].last && month["days"].last["date"] == row["date"]
          month["days"] << { "id" => day_id(row["date"]), "date" => row["date"], "rows" => [] }
        end
        month["days"].last["rows"] << row
        month["row_count"] += 1
        month["entry_count"] += row["n"]
      end
    end

    # The mobile panel's summary (panelSummary): the entries in the calendar month of the
    # newest entry, and that entry's date. It counts entries, as the handoff does, so a
    # same-day double publish counts twice although it shows as one row; the copies of one
    # release count once. nil when empty.
    def panel_summary(data)
      panel_from(entries(data, nil))
    end

    # The id of the row an entry lands in: its merge key. "2026-08-02/release" (one release
    # row per day), "2026-08-03/translation/<series-slug>", "2026-09-27/lectures/<slug>" or
    # "<date>/book/<slug>".
    def row_id(entry)
      id_for(normalise(entry, "entry"))
    end

    # {"start", "end", "label" ("Sep 21–27"), "datetime" (the ISO week, "2026-W39")} for the
    # Monday-to-Sunday week holding `date` (week).
    def week(date)
      day = to_date(iso(date, "a date"))
      monday = day - (day.cwday - 1)
      first = monday.strftime("%Y-%m-%d")
      last = (monday + 6).strftime("%Y-%m-%d")
      { "start" => first, "end" => last, "label" => range(first, last),
        "datetime" => format("%04d-W%02d", day.cwyear, day.cweek) }
    end

    # "Sep 27", "Sep 21–27", "Jul 27 – Aug 2" or "Dec 28, 2026 – Jan 3, 2027" (range).
    def range(first, last)
      a = iso(first, "a date")
      b = iso(last, "a date")
      return short(a) if a == b
      return "#{long(a)} – #{long(b)}" if a[0, 4] != b[0, 4]
      return "#{short(a)}–#{b[8, 2].to_i}" if a[5, 2] == b[5, 2]

      "#{short(a)} – #{short(b)}"
    end

    # "Sep 27"
    def short(date)
      day = iso(date, "a date")
      "#{SHORT_MONTHS[day[5, 2].to_i - 1]} #{day[8, 2].to_i}"
    end

    # "Sep 27, 2026"
    def long(date)
      day = iso(date, "a date")
      "#{short(day)}, #{day[0, 4]}"
    end

    # "September 2026"
    def month_label(date)
      day = iso(date, "a date")
      "#{MONTHS[day[5, 2].to_i - 1]} #{day[0, 4]}"
    end

    private

    # Normalised entries, newest day first and then in the complete entry order, with the
    # copies of each release merged.
    def entries(data, source)
      pairs =
        case data
        when nil, false then []
        when Array then data.each_with_index.map { |entry, i| [entry, "entry #{i + 1}"] }
        when Hash
          data.keys.sort_by(&:to_s).flat_map { |name| file_entries(data[name], [source, name].compact.join("/")) }
        else raise DataError, "Activity data: expected a list of entries or a hash of data files, not #{data.class}"
        end
      list = pairs.map { |entry, where| normalise(entry, where) }
      sorted = list.sort_by { |entry| entry_key(entry) }.group_by(&:date).sort_by(&:first).reverse.flat_map(&:last)
      merge_release_copies(sorted)
    end

    def file_entries(list, file)
      return [] if list.nil? || list == false
      raise DataError, "Activity data: #{file}: expected a list of entries, not #{list.class}" unless list.is_a?(Array)

      list.each_with_index.map { |entry, i| [entry, "#{file}, entry #{i + 1}"] }
    end

    def normalise(entry, where)
      raise DataError, "Activity data: #{where}: an entry must be a mapping, not #{entry.class}" unless entry.is_a?(Hash)

      where = "#{where} (#{entry['project']})" unless entry["project"].to_s.empty?
      unless TYPE_ORDER.include?(entry["type"])
        raise DataError, "Activity data: #{where}: unknown type #{entry['type'].inspect} " \
                         "(expected #{TYPE_ORDER.join(', ')})"
      end
      changes = entry["changes"] || []
      raise DataError, "Activity data: #{where}: changes must be a list" unless changes.is_a?(Array)

      Entry.new(date: iso(entry["date"], where), type: entry["type"], project: entry["project"].to_s,
                url: entry["url"].to_s, version: entry["version"].to_s, summary: entry["summary"].to_s,
                changes: changes.map { |change| pull_request(change, where) })
    end

    def pull_request(change, where)
      unless change.is_a?(Hash)
        raise DataError, "Activity data: #{where}: each change must be a mapping with a title and url"
      end

      url = change["url"].to_s
      number = url[PULL_NUMBER, 1]
      { "title" => change["title"].to_s, "url" => url, "num" => number ? "##{number}" : "" }
    end

    # "2026-09-27" from a Date or a valid YYYY-MM-DD string; anything else is an error.
    def iso(value, where)
      day =
        case value
        when Date then value.strftime("%Y-%m-%d")
        when String then value if value.match?(DAY) && Date.valid_date?(*value.split("-").map(&:to_i))
        end
      day or raise DataError, "Activity data: #{where}: date must be a YYYY-MM-DD day, not #{value.inspect}"
    end

    def to_date(day)
      Date.new(*day.split("-").map(&:to_i))
    end

    # The complete entry order within a day: type, then project (lower-cased, then exact),
    # version, url, summary, the PR urls and, last, the PR titles. Entries that tie on all of
    # these are identical, so no output depends on the input order.
    def entry_key(entry)
      [TYPE_ORDER.index(entry.type), entry.project.downcase, entry.project, entry.version, entry.url,
       entry.summary, entry.changes.map { |change| change["url"] }, entry.changes.map { |change| change["title"] }]
    end

    def text_key(text)
      [text.downcase, text]
    end

    # Merges the copies of a release (entries with the same url on the same day) into the
    # first in the complete order, which gives the project and version. Like a lecture
    # series' double publish, the merged entry joins the distinct summaries (A to Z, with a
    # space) and lists every PR once, so a bare copy never hides one with a summary or PRs.
    def merge_release_copies(list)
      copies = list.select { |entry| entry.type == "release" }.group_by { |entry| [entry.date, entry.url] }
      list.filter_map do |entry|
        next entry unless entry.type == "release"

        same = copies[[entry.date, entry.url]]
        next unless same.first.equal?(entry)
        next entry if same.size == 1

        Entry.new(**entry.to_h.merge(summary: summaries(same).join(" "), changes: pull_requests(same)))
      end
    end

    def rows_from(list)
      list.chunk_while { |a, b| a.date == b.date }.flat_map { |day| day_rows(day.first.date, day) }
    end

    # One day's rows, in TYPE_ORDER: lecture updates, book updates, translations, releases.
    def day_rows(date, day)
      by_type = day.group_by(&:type)
      rows = TYPE_ORDER.flat_map { |type| type_rows(date, type, by_type.fetch(type, [])) }
      check_unique_ids(date, rows)
      rows
    end

    # One type's rows on a day: one row per lecture series or book, one per translated
    # series, and one for all the releases. Rows are ordered A to Z by their series.
    def type_rows(date, type, list)
      case type
      when "release"
        return [] if list.empty?

        [list.size == 1 ? single(list.first) : release_group(date, list)]
      when "translation"
        list.group_by { |entry| series(entry.project).first }.sort_by { |name, _| text_key(name) }
            .map { |name, group| group.size == 1 ? single(group.first) : editions(date, name, group) }
      else
        list.group_by(&:project).sort_by { |project, _| text_key(project) }.map { |_, group| site_row(group) }
      end
    end

    def row(entry, fields)
      {
        "id" => id_for(entry), "date" => entry.date, "date_label" => short(entry.date), "type" => entry.type,
        "kind" => "single", "n" => 1, "type_word" => TYPE_WORD[entry.type], "title" => entry.project,
        "version" => "", "url" => entry.url, "tag" => "", "summary" => "", "changes" => [], "releases" => [],
        "editions" => [], "per_edition" => nil,
      }.merge(fields)
    end

    # A single release or translation.
    def single(entry)
      name, language = series(entry.project)
      translation = entry.type == "translation"
      row(entry, "title" => translation ? name : entry.project, "version" => entry.version,
                 "tag" => translation ? language : "", "summary" => entry.summary, "changes" => pull_requests([entry]))
    end

    # A lecture series or book: one ordinary row, however many times it published that day.
    # The row links to the site, has no tag, joins the distinct summaries (A to Z, with a
    # space) and lists every PR once.
    def site_row(group)
      first = group.first
      row(first, "n" => group.size, "version" => group.size == 1 ? first.version : "",
                 "summary" => summaries(group).join(" "), "changes" => pull_requests(group))
    end

    # A day's releases, when there are several: the title lists each project once.
    def release_group(date, group)
      row(group.first, "kind" => "group", "n" => group.size, "type_word" => MERGED_TYPE_WORD["release"],
                       "title" => and_list(group.map(&:project).uniq), "url" => day_url(date),
                       "tag" => "#{group.size} releases · same day",
                       "releases" => group.map { |e| { "project" => e.project, "version" => e.version, "url" => e.url } })
    end

    # A series' translations on one day, when there are several: one row listing each
    # language once. When the entries have exactly one distinct summary (entries without
    # one don't count), it is the row's summary; with two or more, per_edition gives each
    # edition its own, and an edition without one gets an empty list.
    def editions(date, name, group)
      by_language = group.group_by { |entry| series(entry.project).last }
      languages = by_language.keys.sort_by { |language| text_key(language) }
      list = languages.map do |language|
        mine = by_language[language]
        { "lang" => language, "url" => mine.first.url, "summaries" => summaries(mine) }
      end
      distinct = group.map(&:summary).reject(&:empty?).uniq
      row(group.first, "kind" => "editions", "n" => group.size, "type_word" => MERGED_TYPE_WORD["translation"],
                       "title" => name, "url" => day_url(date),
                       "tag" => languages.size == 1 ? "1 edition" : "#{languages.size} editions",
                       "summary" => distinct.size == 1 ? distinct.first : "", "editions" => list,
                       "per_edition" => distinct.size > 1 ? list : nil,
                       "changes" => pull_requests(languages.flat_map { |language| by_language[language] }))
    end

    def summaries(group)
      group.map(&:summary).reject(&:empty?).uniq.sort_by { |summary| text_key(summary) }
    end

    # Every PR once (by url), in the entries' order and then each entry's own order.
    def pull_requests(group)
      seen = {}
      group.flat_map(&:changes).select { |change| seen[change["url"]] ? false : (seen[change["url"]] = true) }
    end

    # ["Series", "Language"] for a translated edition; [project, ""] otherwise.
    def series(project)
      match = SERIES.match(project)
      match ? [match[1], match[2]] : [project, ""]
    end

    def id_for(entry)
      case entry.type
      when "release" then "#{entry.date}/release"
      when "translation" then "#{entry.date}/translation/#{slug(series(entry.project).first)}"
      else "#{entry.date}/#{entry.type}/#{slug(entry.project)}"
      end
    end

    # Lower-case letters and digits, with a hyphen for each run of anything else.
    def slug(text)
      slug = text.downcase.gsub(/[^\p{L}\p{M}\p{Nd}]+/, "-").delete_prefix("-").delete_suffix("-")
      slug.empty? ? "untitled" : slug
    end

    # Two series whose names differ only in case or punctuation would share an id.
    def check_unique_ids(date, rows)
      rows.group_by { |row| row["id"] }.each_value do |same|
        next if same.size == 1

        titles = same.map { |row| %("#{row['title']}") }.join(" and ")
        raise DataError, "Activity data: #{titles} on #{date} would share the row id #{same.first['id']}; " \
                         "their names must differ in more than case or punctuation"
      end
    end

    def and_list(items)
      return items.join(" and ") if items.size < 3

      "#{items[0..-2].join(', ')} and #{items[-1]}"
    end

    def day_id(date)
      "activity-#{date}"
    end

    def day_url(date)
      "/activity/##{day_id(date)}"
    end

    def panel_from(list)
      return nil if list.empty?

      latest = list.map(&:date).max
      count = list.count { |entry| entry.date[0, 7] == latest[0, 7] }
      month = MONTHS[latest[5, 2].to_i - 1]
      { "entry_count" => count, "month" => month, "latest" => short(latest), "latest_iso" => latest,
        "text" => "#{count} #{count == 1 ? 'update' : 'updates'} in #{month} · latest #{short(latest)}" }
    end
  end
end
