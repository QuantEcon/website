# frozen_string_literal: true

# Tests for the Activity rows (_plugins/activity/rows.rb). Run them with plain ruby:
#
#   ruby .github/scripts/test-activity.rb
#
# Minitest ships with Ruby but isn't in the Gemfile, so `bundle exec` can't load it. CI runs
# this file in the build job, right after the data check.
#
# - Fixed numbers are checked against fixtures/activity/: a frozen, verbatim copy of the 23
#   files and 40 entries in _data/activity/ at commit 4c47f03. Don't edit it or add to it.
# - Synthetic entries, defined in this file, cover the cases the fixture lacks.
# - The live data in _data/activity/ is checked only for rules that stay true as entries
#   are added.
#
# This file lives outside _plugins/, whose every .rb file Jekyll loads, and the fixture
# outside _data/, which Jekyll would read into site.data.
require "minitest/autorun"
require "date"
require "yaml"
require_relative "../../_plugins/activity/rows"

module ActivityTestData
  FIXTURE = File.expand_path("fixtures/activity", __dir__)
  LIVE = File.expand_path("../../_data/activity", __dir__)

  IQ = "Intermediate Quantitative Economics with Python"
  FC = "A First Course in Quantitative Economics with Python"
  PP = "Python Programming for Economics and Finance"
  IQ_URL = "https://python.quantecon.org/"
  FR_URL = "https://quantecon.github.io/lecture-python-programming.fr/"
  FA_URL = "https://quantecon.github.io/lecture-python-programming.fa/"
  SWITCHER = "Enabled the language switcher between the English, Persian, French and Simplified Chinese editions."

  module_function

  # A data directory as Jekyll reads it into site.data: file name => entries, with dates as
  # Date objects.
  def load_dir(dir)
    Dir[File.join(dir, "*.{yml,yaml}")].sort.to_h do |path|
      [File.basename(path, ".*"), YAML.safe_load(File.read(path), permitted_classes: [Date])]
    end
  end

  def fixture
    load_dir(FIXTURE)
  end

  def pr(repo, number, title)
    { "title" => title, "url" => "https://github.com/QuantEcon/#{repo}/pull/#{number}" }
  end

  def entry(date, type, project, url, summary = nil, changes = nil)
    result = { "date" => date, "type" => type, "project" => project, "url" => url }
    result["summary"] = summary if summary
    result["changes"] = changes if changes
    result
  end

  def lecture(date, project, url, summary = nil, changes = nil)
    entry(date, "lectures", project, url, summary, changes)
  end

  def book(date, project, url, summary = nil, changes = nil)
    entry(date, "book", project, url, summary, changes)
  end

  def translation(date, project, url, summary = nil, changes = nil)
    entry(date, "translation", project, url, summary, changes)
  end

  def release(date, project, version)
    { "date" => date, "type" => "release", "project" => project, "version" => version,
      "url" => "https://github.com/QuantEcon/#{project}/releases/tag/#{version}" }
  end

  # One day that needs every rule at once. Several entries tie on everything but their
  # summaries, PRs or PR titles, so only a complete order keeps the merged rows the same
  # under any input order.
  def busy_day
    day = "2026-10-05"
    py = "lecture-python.myst"
    [
      lecture(day, IQ, IQ_URL, "Added exercises.", [pr(py, 1071, "Add exercises")]),
      lecture(day, IQ, IQ_URL, "Added exercises.", [pr(py, 1072, "Add more exercises")]),
      lecture(day, IQ, IQ_URL, "Added a lecture.", [pr(py, 1071, "Add exercises (retitled)")]),
      lecture(Date.new(2026, 10, 5), IQ, IQ_URL, "Added a lecture.", [pr(py, 1071, "Add exercises")]),
      lecture(day, IQ, IQ_URL, nil, [pr(py, 1073, "Fix a typo")]),
      book(day, "Dynamic Programming", "https://dp.quantecon.org/", "Revised chapter 3.",
           [pr("book-dp-public", 12, "Revise chapter 3")]),
      book(day, "Dynamic Programming", "https://dp.quantecon.org/", "Fixed the figures.",
           [pr("book-dp-public", 13, "Fix figures")]),
      translation(day, "#{PP} (French)", FR_URL, "Translated the NumPy lecture.",
                  [pr("lecture-python-programming.fr", 30, "Translate NumPy")]),
      translation(day, "#{PP} (French)", FR_URL, "Fixed typos.", [pr("lecture-python-programming.fr", 31, "Fix typos")]),
      translation(day, "#{PP} (Persian)", FA_URL, nil, [pr("lecture-python-programming.fa", 150, "Sync")]),
      release(day, "GameTheory.jl", "v0.7.3"),
      release(day, "GameTheory.jl", "v0.7.10"),
      release(day, "QuantEcon.py", "v0.12.1"),
      release(day, "QuantEcon.py", "v0.12.1"),
      release(day, "QuantEcon.py", "v0.12.1").merge("project" => "Quantecon.py"),
    ]
  end

  # One day that pins the rest of the order, with each type listed here out of order. Byte
  # by byte, a lower-case name sorts after every capitalised one, so only an order that
  # ignores case puts "alpha" before "Beta", "french" before "German" and "gametracer"
  # before "QuantEcon.py". Two lecture entries differ only in url, two only in their PRs'
  # urls, and two copies of one release only in version, so those tie-breakers alone keep
  # the output the same under any input order.
  def order_day
    day = "2026-10-07"
    alpha = "https://alpha.example.org/"
    [
      lecture(day, "Beta Lectures", "https://beta.example.org/", "Fixed typos.", [pr("beta", 5, "Fix typos")]),
      lecture(day, "Beta Lectures", "https://beta.example.org/", "Fixed typos.", [pr("beta", 4, "Fix typos")]),
      lecture(day, "alpha Lectures", "#{alpha}b/", "Added a lecture.", [pr("alpha", 1, "Add a lecture")]),
      lecture(day, "alpha Lectures", alpha, "Added a lecture.", [pr("alpha", 1, "Add a lecture")]),
      translation(day, "Zeta Series (French)", "https://zeta.example.org/fr/", "Translated a lecture."),
      translation(day, "Beta Series (German)", "https://beta.example.org/de/", "Translated a lecture.",
                  [pr("beta.de", 2, "Translate a lecture")]),
      translation(day, "Beta Series (french)", "https://beta.example.org/fr/", "Translated a lecture.",
                  [pr("beta.fr", 3, "Translate a lecture")]),
      translation(day, "alpha Series (Persian)", "#{alpha}fa/", "Translated a lecture."),
      release(day, "QuantEcon.py", "v0.12.2"),
      release(day, "QuantEcon.py", "v0.12.2").merge("version" => "0.12.2"),
      release(day, "gametracer", "0.2.3"),
    ]
  end

  # "Sep 24 QuantEcon.py v0.12.0", with " · <tag>" when the row has one.
  def line(row)
    text = [row["date_label"], row["title"], row["version"]].reject(&:empty?).join(" ")
    row["tag"].empty? ? text : "#{text} · #{row['tag']}"
  end

  def ids(rows)
    rows.map { |row| row["id"] }
  end
end

module ActivityAssertions
  # Every hash key is a string, and every value a string, integer, boolean, nil, list or
  # hash: what Liquid can read.
  def assert_plain(value, path = "view")
    case value
    when Hash
      value.each do |key, item|
        assert_kind_of String, key, "#{path} has a non-string key #{key.inspect}"
        assert_plain(item, "#{path}.#{key}")
      end
    when Array then value.each_with_index { |item, i| assert_plain(item, "#{path}[#{i}]") }
    else
      assert [String, Integer, TrueClass, FalseClass, NilClass].any? { |kind| value.is_a?(kind) },
             "#{path} is a #{value.class}"
    end
  end
end

# The acceptance numbers, on the frozen fixture.
class FixtureTest < Minitest::Test
  include ActivityTestData

  def setup
    @view = ActivityRows.view(fixture)
    @rows = @view["rows"]
  end

  def rail(filter)
    ActivityRows.by_week(ActivityRows.rail_rows(@rows, filter))
  end

  def test_the_fixture_is_the_frozen_copy
    data = fixture
    assert_equal 23, data.size
    assert_equal 40, data.values.sum(&:size)
  end

  def test_rail_all
    weeks = rail("all")
    assert_equal ["Sep 21–27", "Sep 14–20"], weeks.map { |week| week["label"] }
    assert_equal %w[2026-W39 2026-W38], weeks.map { |week| week["datetime"] }
    assert_equal ["Sep 27 #{IQ}", "Sep 24 QuantEcon.py v0.12.0", "Sep 23 GameTheory.jl v0.7.2",
                  "Sep 19 jlgametheory v0.3.0", "Sep 16 GameTracer.jl v0.2.0", "Sep 14 gametracer 0.2.2"],
                 weeks.flat_map { |week| week["rows"] }.map { |row| line(row) }
  end

  def test_rail_releases
    weeks = rail("release")
    assert_equal ["Sep 21–27", "Sep 14–20", "Aug 10–16"], weeks.map { |week| week["label"] }
    assert_equal ["Sep 24 QuantEcon.py v0.12.0", "Sep 23 GameTheory.jl v0.7.2", "Sep 19 jlgametheory v0.3.0",
                  "Sep 16 GameTracer.jl v0.2.0", "Sep 14 gametracer 0.2.2", "Aug 16 jlgametheory v0.2.0"],
                 weeks.flat_map { |week| week["rows"] }.map { |row| line(row) }
  end

  def test_rail_lectures
    weeks = rail("lectures")
    assert_equal ["Sep 21–27", "Aug 17–23", "Aug 3–9", "Jul 20–26"], weeks.map { |week| week["label"] }
    assert_equal ["Sep 27 #{IQ}", "Aug 19 #{FC}", "Aug 6 #{FC}", "Aug 3 #{PP}", "Jul 26 #{IQ}", "Jul 23 #{IQ}"],
                 weeks.flat_map { |week| week["rows"] }.map { |row| line(row) }
  end

  def test_rail_translations
    assert_equal ["Aug 20 #{FC} · Simplified Chinese", "Aug 3 #{PP} · 3 editions"],
                 rail("translation").flat_map { |week| week["rows"] }.map { |row| line(row) }
  end

  def test_rail_books_is_empty
    assert_equal [], ActivityRows.rail_rows(@rows, "book")
  end

  def test_the_rendered_rail_holds_the_latest_six_of_each_type
    rows = @view["rail"].flat_map { |week| week["rows"] }
    assert_equal 14, rows.size
    assert_equal %w[2026-W39 2026-W38 2026-W34 2026-W33 2026-W32 2026-W30], @view["rail"].map { |week| week["datetime"] }
    assert_equal [true, true, false, false, false, false], @view["rail"].map { |week| week["has_all"] }
    assert_equal ActivityTestData.ids(ActivityRows.rail_rows(@rows, "all")),
                 ActivityTestData.ids(rows.select { |row| row["in_all"] })
    ActivityRows::TYPE_ORDER.each do |type|
      assert_equal ActivityTestData.ids(ActivityRows.rail_rows(@rows, type)),
                   ActivityTestData.ids(rows.select { |row| row["type"] == type }), type
    end
  end

  def test_strip
    assert_equal ["Sep 27 #{IQ}", "Sep 24 QuantEcon.py v0.12.0", "Sep 23 GameTheory.jl v0.7.2"],
                 @view["strip"].map { |row| line(row) }
  end

  def test_panel
    assert_equal({ "entry_count" => 6, "month" => "September", "latest" => "Sep 27", "latest_iso" => "2026-09-27",
                   "text" => "6 updates in September · latest Sep 27" }, @view["panel"])
  end

  def test_log_has_30_rows_across_four_months
    months = @view["months"]
    assert_equal 30, @rows.size
    assert_equal ["September 2026", "August 2026", "July 2026", "June 2026"], months.map { |month| month["label"] }
    assert_equal %w[activity-2026-09 activity-2026-08 activity-2026-07 activity-2026-06], months.map { |month| month["id"] }
    assert_equal [6, 8, 11, 5], months.map { |month| month["row_count"] }
    assert_equal [6, 13, 15, 6], months.map { |month| month["entry_count"] }
    assert_equal [6, 8, 11, 5], months.map { |month| month["days"].sum { |day| day["rows"].size } }
    assert_equal "2026-06-12", @view["first_date"]
    assert_equal "Jun 12, 2026", @view["first_date_label"]
  end

  def test_the_august_2_release_group
    day = @view["months"][1]["days"].find { |item| item["id"] == "activity-2026-08-02" }
    row = day["rows"].first
    assert_equal({ "id" => "2026-08-02/release", "kind" => "group", "n" => 4, "type_word" => "Releases:",
                   "title" => "BasisMatrices.jl, ContinuousDPs.jl, GameTheory.jl and QuantEcon.jl",
                   "url" => "/activity/#activity-2026-08-02", "tag" => "4 releases · same day" },
                 row.slice("id", "kind", "n", "type_word", "title", "url", "tag"))
    assert_equal ["BasisMatrices.jl v0.8.2", "ContinuousDPs.jl v0.3.2", "GameTheory.jl v0.7.1", "QuantEcon.jl v0.19.0"],
                 row["releases"].map { |item| "#{item['project']} #{item['version']}" }
  end

  def test_the_august_3_lecture_update_then_editions
    update, editions = @rows.select { |row| row["date"] == "2026-08-03" }
    assert_equal %w[lectures single], update.values_at("type", "kind")
    assert_equal ["2026-08-03/translation/python-programming-for-economics-and-finance", "editions", 3,
                  "Translations:", PP, "/activity/#activity-2026-08-03", "3 editions", SWITCHER],
                 editions.values_at("id", "kind", "n", "type_word", "title", "url", "tag", "summary")
    assert_equal ["French", "Persian", "Simplified Chinese"], editions["editions"].map { |item| item["lang"] }
    assert_nil editions["per_edition"]
    # Edition order: the prototype lists these in file order (#145, #21, #80).
    assert_equal %w[#21 #145 #80], editions["changes"].map { |change| change["num"] }
  end

  def test_a_day_lists_lecture_updates_before_releases
    assert_equal [["lectures", IQ], ["release", "ContinuousDPs.jl"]],
                 @rows.select { |row| row["date"] == "2026-07-26" }.map { |row| row.values_at("type", "title") }
    assert_equal [["lectures", "Advanced Quantitative Economics with Python"], ["lectures", IQ]],
                 @rows.select { |row| row["date"] == "2026-07-07" }.map { |row| row.values_at("type", "title") }
  end

  def test_a_single_row
    assert_equal({ "id" => "2026-09-27/lectures/intermediate-quantitative-economics-with-python",
                   "date" => "2026-09-27", "date_label" => "Sep 27", "type" => "lectures", "kind" => "single", "n" => 1,
                   "type_word" => "Lecture update:", "title" => IQ, "version" => "", "url" => IQ_URL, "tag" => "",
                   "releases" => [], "editions" => [], "per_edition" => nil },
                 @rows.first.reject { |key, _| %w[summary changes].include?(key) })
    assert_equal %w[#1070 #1069 #1068], @rows.first["changes"].map { |change| change["num"] }
  end
end

# The same output whatever the order of files and entries, the date type or the timezone.
class OrderTest < Minitest::Test
  include ActivityTestData

  def data
    fixture.merge("2026-10-05-busy" => busy_day, "2026-10-07-order" => order_day)
  end

  def test_shuffled_entries_and_file_order_give_identical_output
    baseline = ActivityRows.view(data)
    random = Random.new(276)
    60.times do
      shuffled = data.to_a.shuffle(random: random).to_h { |name, list| [name, list.shuffle(random: random)] }
      assert_equal baseline, ActivityRows.view(shuffled)
    end
  end

  def test_entries_moved_between_files_give_identical_output
    list = data.values.flatten(1)
    baseline = ActivityRows.view(list)
    random = Random.new(271)
    60.times do
      shuffled = list.shuffle(random: random)
      files = shuffled.each_slice(random.rand(1..9)).each_with_index.to_h { |slice, i| ["file-#{random.rand(999)}-#{i}", slice] }
      assert_equal baseline, ActivityRows.view(shuffled)
      assert_equal baseline, ActivityRows.view(files)
    end
  end

  def test_date_objects_and_strings_give_the_same_output
    strings = data.transform_values { |list| list.map { |item| item.merge("date" => item["date"].to_s) } }
    dates = data.transform_values { |list| list.map { |item| item.merge("date" => Date.parse(item["date"].to_s)) } }
    assert_equal ActivityRows.view(strings), ActivityRows.view(dates)
    assert_equal ActivityRows.view(strings), ActivityRows.view(data)
  end

  def test_the_timezone_changes_nothing
    original = ENV.fetch("TZ", nil)
    views = ["Australia/Sydney", "UTC", "Pacific/Kiritimati", "America/Los_Angeles", "Pacific/Pago_Pago"].map do |zone|
      ENV["TZ"] = zone
      ActivityRows.view(data)
    end
    views.each { |view| assert_equal views.first, view }
  ensure
    if original
      ENV["TZ"] = original
    else
      ENV.delete("TZ")
    end
  end
end

# Week and date labels, computed from calendar days without Time.
class DatesTest < Minitest::Test
  def test_iso_weeks
    assert_equal({ "start" => "2026-12-28", "end" => "2027-01-03", "label" => "Dec 28, 2026 – Jan 3, 2027",
                   "datetime" => "2026-W53" }, ActivityRows.week("2026-12-28"))
    assert_equal "2026-W53", ActivityRows.week("2027-01-03")["datetime"]
    assert_equal({ "start" => "2029-12-31", "end" => "2030-01-06", "label" => "Dec 31, 2029 – Jan 6, 2030",
                   "datetime" => "2030-W01" }, ActivityRows.week(Date.new(2029, 12, 31)))
    assert_equal({ "start" => "2026-09-21", "end" => "2026-09-27", "label" => "Sep 21–27", "datetime" => "2026-W39" },
                 ActivityRows.week("2026-09-27"))
    assert_equal "Jul 27 – Aug 2", ActivityRows.week("2026-08-02")["label"]
  end

  # Checks every week from 2024 to 2032 against the ISO 8601 rule: a week runs Monday to
  # Sunday and belongs to the year of its Thursday.
  def test_weeks_run_monday_to_sunday_with_iso_numbers
    (Date.new(2024, 1, 1)..Date.new(2032, 12, 31)).each do |day|
      week = ActivityRows.week(day)
      monday = Date.parse(week["start"])
      thursday = monday + 3
      assert_equal 1, monday.wday, "#{day}: #{week['start']} is not a Monday"
      assert_equal (monday + 6).to_s, week["end"]
      assert_includes monday..(monday + 6), day
      assert_equal format("%04d-W%02d", thursday.year, ((thursday.yday - 1) / 7) + 1), week["datetime"], day.to_s
    end
  end

  def test_ranges_and_labels
    assert_equal "Sep 27", ActivityRows.range("2026-09-27", "2026-09-27")
    assert_equal "Sep 21–27", ActivityRows.range("2026-09-21", Date.new(2026, 9, 27))
    assert_equal "Jul 27 – Aug 2", ActivityRows.range("2026-07-27", "2026-08-02")
    assert_equal "Dec 28, 2026 – Jan 3, 2027", ActivityRows.range("2026-12-28", "2027-01-03")
    assert_equal "Sep 7", ActivityRows.short(Date.new(2026, 9, 7))
    assert_equal "Jun 12, 2026", ActivityRows.long("2026-06-12")
    assert_equal "September 2026", ActivityRows.month_label("2026-09-27")
  end

  def test_a_date_must_be_a_calendar_day
    ["2026-9-27", "2026-02-30", "27/09/2026", "", nil, Time.utc(2026, 9, 27, 12)].each do |date|
      error = assert_raises(ActivityRows::DataError, date.inspect) do
        ActivityRows.view({ "2026-09-27-lectures" => [ActivityTestData.lecture(date, "X", "https://x.org/")] },
                          source: "_data/activity")
      end
      assert_includes error.message, "_data/activity/2026-09-27-lectures, entry 1 (X): date must be a YYYY-MM-DD day"
    end
  end
end

# Row ids: the merge key, unique, and stable as the data changes.
class RowIdTest < Minitest::Test
  include ActivityTestData

  def test_ids_are_the_merge_key
    assert_equal "2026-08-02/release", ActivityRows.row_id(release("2026-08-02", "QuantEcon.jl", "v0.19.0"))
    assert_equal "2026-08-03/translation/python-programming-for-economics-and-finance",
                 ActivityRows.row_id(translation(Date.new(2026, 8, 3), "#{PP} (French)", FR_URL))
    assert_equal "2026-09-27/lectures/intermediate-quantitative-economics-with-python",
                 ActivityRows.row_id(lecture("2026-09-27", IQ, IQ_URL))
    assert_equal "2026-10-05/book/dynamic-programming",
                 ActivityRows.row_id(book("2026-10-05", "Dynamic Programming", "https://dp.quantecon.org/"))
  end

  def test_ids_are_unique
    [fixture, busy_day, order_day, fixture.merge("busy" => busy_day, "order" => order_day)].each do |data|
      found = ActivityTestData.ids(ActivityRows.build_rows(data))
      assert_equal found.uniq, found
      found.each { |id| assert_match %r{\A\d{4}-\d{2}-\d{2}/(release|(lectures|book|translation)/[\p{L}\p{M}\p{Nd}-]+)\z}, id }
    end
  end

  def test_ids_do_not_change_when_a_same_day_release_is_added
    data = fixture
    before = ActivityTestData.ids(ActivityRows.build_rows(data))
    data["2026-09-24-software"] += [release("2026-09-24", "QuantEcon.jl", "v0.20.0")]
    rows = ActivityRows.build_rows(data)
    assert_equal before, ActivityTestData.ids(rows)
    row = rows.find { |item| item["id"] == "2026-09-24/release" }
    assert_equal ["group", "QuantEcon.jl and QuantEcon.py", "2 releases · same day"], row.values_at("kind", "title", "tag")
  end

  def test_ids_do_not_change_when_an_edition_or_a_second_publish_joins_a_row
    data = fixture
    before = ActivityTestData.ids(ActivityRows.build_rows(data))
    data["extra"] = [translation("2026-08-20", "#{FC} (French)", "https://quantecon.github.io/lecture-intro.fr/"),
                     lecture("2026-09-27", IQ, IQ_URL, "Fixed a figure.")]
    rows = ActivityRows.build_rows(data)
    assert_equal before, ActivityTestData.ids(rows)
    assert_equal ["editions", 2], rows.find { |row| row["date"] == "2026-08-20" }.values_at("kind", "n")
    assert_equal ["single", 2], rows.first.values_at("kind", "n")
  end

  def test_ids_are_stable_under_shuffling
    list = fixture.values.flatten(1) + busy_day + order_day
    expected = ActivityTestData.ids(ActivityRows.build_rows(list))
    random = Random.new(280)
    50.times { assert_equal expected, ActivityTestData.ids(ActivityRows.build_rows(list.shuffle(random: random))) }
  end

  def test_series_whose_names_would_share_an_id_fail_loudly
    error = assert_raises(ActivityRows::DataError) do
      ActivityRows.build_rows([lecture("2026-10-01", "QuantEcon Notes", "https://a.org/"),
                               lecture("2026-10-01", "QuantEcon notes", "https://b.org/")])
    end
    assert_includes error.message, "2026-10-01/lectures/quantecon-notes"
  end
end

# The amendments and decisions, each on a small synthetic case.
class RulesTest < Minitest::Test
  include ActivityTestData

  def test_a_day_orders_lectures_book_translations_then_releases
    rows = ActivityRows.build_rows(busy_day.reverse)
    assert_equal %w[lectures book translation release], rows.map { |row| row["type"] }
    assert_equal ["Lecture update:", "Book update:", "Translations:", "Releases:"], rows.map { |row| row["type_word"] }
  end

  def test_a_series_published_twice_in_a_day_is_one_ordinary_row
    first = lecture("2026-09-27", IQ, IQ_URL, "Added exercises.",
                    [pr("lecture-python.myst", 1071, "Add exercises"), pr("lecture-python.myst", 1070, "Two sequels")])
    second = lecture("2026-09-27", IQ, IQ_URL, "Added a lecture.",
                     [pr("lecture-python.myst", 1070, "Two sequels"), pr("lecture-python.myst", 1072, "New lecture")])
    rows = ActivityRows.build_rows([first, second])
    assert_equal 1, rows.size
    assert_equal ["2026-09-27/lectures/intermediate-quantitative-economics-with-python", "single", 2, "Lecture update:",
                  IQ, "", IQ_URL, "", "Added a lecture. Added exercises."],
                 rows.first.values_at("id", "kind", "n", "type_word", "title", "version", "url", "tag", "summary")
    assert_equal %w[#1070 #1072 #1071], rows.first["changes"].map { |change| change["num"] }
    # The panel counts entries, as the handoff does: two here, for one row.
    assert_equal "2 updates in September · latest Sep 27", ActivityRows.panel_summary([first, second])["text"]
  end

  # Entries sort by url before summary, so these arrive "Zeta." first: the joined summaries
  # must still run A to Z, ignoring case.
  def test_merged_summaries_run_a_to_z_ignoring_case
    site = ActivityRows.build_rows([lecture("2026-10-03", IQ, IQ_URL, "Zeta."),
                                    lecture("2026-10-03", IQ, "#{IQ_URL}b/", "alpha.")]).first
    assert_equal ["alpha. Zeta.", IQ_URL], site.values_at("summary", "url")
    editions = ActivityRows.build_rows([translation("2026-10-03", "#{PP} (French)", FR_URL, "Zeta."),
                                        translation("2026-10-03", "#{PP} (French)", "#{FR_URL}b/", "alpha.")]).first
    assert_equal [["French", FR_URL, ["alpha.", "Zeta."]]],
                 editions["per_edition"].map { |item| item.values_at("lang", "url", "summaries") }
  end

  def test_the_busy_day_merges_every_series_once
    lectures, dp, editions, releases = ActivityRows.build_rows(busy_day)
    assert_equal [5, "Added a lecture. Added exercises."], lectures.values_at("n", "summary")
    assert_equal [["#1073", "Fix a typo"], ["#1071", "Add exercises"], ["#1072", "Add more exercises"]],
                 lectures["changes"].map { |change| change.values_at("num", "title") }
    assert_equal ["2026-10-05/book/dynamic-programming", "single", 2, "Fixed the figures. Revised chapter 3."],
                 dp.values_at("id", "kind", "n", "summary")
    assert_equal ["2 editions", 3, ""], editions.values_at("tag", "n", "summary")
    assert_equal [["French", ["Fixed typos.", "Translated the NumPy lecture."]], ["Persian", []]],
                 editions["per_edition"].map { |item| item.values_at("lang", "summaries") }
    assert_equal %w[#31 #30 #150], editions["changes"].map { |change| change["num"] }
    assert_equal ["GameTheory.jl and QuantEcon.py", "3 releases · same day", 3], releases.values_at("title", "tag", "n")
    assert_equal ["GameTheory.jl v0.7.10", "GameTheory.jl v0.7.3", "QuantEcon.py v0.12.1"],
                 releases["releases"].map { |item| "#{item['project']} #{item['version']}" }
  end

  def test_one_project_released_twice_in_a_day_is_listed_once
    rows = ActivityRows.build_rows([release("2026-10-03", "GameTheory.jl", "v0.7.3"),
                                    release("2026-10-03", "GameTheory.jl", "v0.7.2")])
    assert_equal [["group", "GameTheory.jl", "2 releases · same day", "/activity/#activity-2026-10-03"]],
                 rows.map { |row| row.values_at("kind", "title", "tag", "url") }
    assert_equal %w[v0.7.2 v0.7.3], rows.first["releases"].map { |item| item["version"] }
  end

  def test_an_exact_duplicate_release_is_dropped
    twice = [release("2026-09-19", "jlgametheory", "v0.3.0"), release("2026-09-19", "jlgametheory", "v0.3.0")]
    rows = ActivityRows.build_rows(twice)
    assert_equal [["single", 1, "jlgametheory", "v0.3.0", "2026-09-19/release"]],
                 rows.map { |row| row.values_at("kind", "n", "title", "version", "id") }
    assert_equal 1, ActivityRows.panel_summary(twice)["entry_count"]
    group = ActivityRows.build_rows(twice + [release("2026-09-19", "GameTracer.jl", "v0.2.1")]).first
    assert_equal ["GameTracer.jl and jlgametheory", "2 releases · same day", 2], group.values_at("title", "tag", "n")
  end

  # The copies of one release (the same url on the same day) merge like a double publish,
  # so a bare copy never hides one with a summary and PRs.
  def test_copies_of_one_release_merge_their_summaries_and_prs
    bare = release("2026-10-07", "QuantEcon.py", "v0.12.1")
    jax = bare.merge("summary" => "Adds a JAX backend.", "changes" => [pr("QuantEcon.py", 800, "Add a JAX backend")])
    numba = bare.merge("summary" => "Adds a Numba backend.",
                       "changes" => [pr("QuantEcon.py", 801, "Add a Numba backend"), pr("QuantEcon.py", 800, "Add a JAX backend")])
    [[bare, jax], [jax, bare]].each do |pair|
      row = ActivityRows.build_rows(pair).first
      assert_equal ["single", 1, "v0.12.1", "Adds a JAX backend."], row.values_at("kind", "n", "version", "summary")
      assert_equal %w[#800], row["changes"].map { |change| change["num"] }
    end
    row = ActivityRows.build_rows([numba, bare, jax]).first
    assert_equal "Adds a JAX backend. Adds a Numba backend.", row["summary"]
    assert_equal %w[#800 #801], row["changes"].map { |change| change["num"] }
    assert_equal "1 update in October · latest Oct 7", ActivityRows.panel_summary([numba, bare, jax])["text"]
  end

  # Names run A to Z ignoring case: lecture rows, translated series, a row's editions (and
  # so its PRs), and a release group's title and releases.
  def test_names_run_a_to_z_ignoring_case
    rows = ActivityRows.build_rows(order_day)
    assert_equal [["alpha Lectures", ""], ["Beta Lectures", ""], ["alpha Series", "Persian"], ["Beta Series", "2 editions"],
                  ["Zeta Series", "French"], ["gametracer and QuantEcon.py", "2 releases · same day"]],
                 rows.map { |row| row.values_at("title", "tag") }
    assert_equal %w[french German], rows[3]["editions"].map { |item| item["lang"] }
    assert_equal %w[#3 #2], rows[3]["changes"].map { |change| change["num"] }
    assert_equal ["gametracer 0.2.3", "QuantEcon.py 0.12.2"],
                 rows.last["releases"].map { |item| "#{item['project']} #{item['version']}" }
  end

  # Entries that tie on everything but their version, url or PR urls are ordered by it in
  # either input order: the copies of a release take their version, and a merged row its
  # url, from the first entry, and a merged row lists its PRs in entry order.
  def test_the_version_url_and_pr_urls_break_ties
    tagged = release("2026-10-07", "QuantEcon.py", "v0.12.2")
    bare = tagged.merge("version" => "0.12.2")
    [[tagged, bare], [bare, tagged]].each do |pair|
      assert_equal ["single", 1, "0.12.2", tagged["url"]], ActivityRows.build_rows(pair).first.values_at("kind", "n", "version", "url")
    end
    first = lecture("2026-10-07", "alpha Lectures", "https://alpha.example.org/", "Added a lecture.")
    second = first.merge("url" => "https://alpha.example.org/b/")
    [[first, second], [second, first]].each do |pair|
      assert_equal "https://alpha.example.org/", ActivityRows.build_rows(pair).first["url"]
    end
    later = lecture("2026-10-07", "Beta Lectures", "https://beta.example.org/", "Fixed typos.", [pr("beta", 5, "Fix typos")])
    earlier = later.merge("changes" => [pr("beta", 4, "Fix typos")])
    [[later, earlier], [earlier, later]].each do |pair|
      assert_equal %w[#4 #5], ActivityRows.build_rows(pair).first["changes"].map { |change| change["num"] }
    end
  end

  def test_a_same_language_translation_pair_is_one_edition
    pair = [translation("2026-10-04", "#{PP} (French)", FR_URL, "Translated the NumPy lecture."),
            translation("2026-10-04", "#{PP} (French)", FR_URL, "Fixed typos.")]
    row = ActivityRows.build_rows(pair).first
    assert_equal ["editions", "1 edition", 2, "/activity/#activity-2026-10-04", "", "Translations:"],
                 row.values_at("kind", "tag", "n", "url", "summary", "type_word")
    assert_equal [{ "lang" => "French", "url" => FR_URL, "summaries" => ["Fixed typos.", "Translated the NumPy lecture."] }],
                 row["per_edition"]
    same = ActivityRows.build_rows(pair.map { |item| item.merge("summary" => "Fixed typos.") }).first
    assert_equal ["1 edition", "Fixed typos."], same.values_at("tag", "summary")
    assert_nil same["per_edition"]
  end

  # The handoff's PH_EDITIONS_DIFF: the Aug 20 Simplified Chinese entry moved to Aug 3 as a
  # Python Programming edition, so the summaries differ and one language has two entries.
  def test_merged_translations_with_differing_summaries
    data = fixture.values.flatten(1)
    aug3 = data.select { |item| item["date"].to_s == "2026-08-03" && item["type"] == "translation" }
    moved = data.find { |item| item["date"].to_s == "2026-08-20" }.merge("date" => "2026-08-03",
                                                                         "project" => "#{PP} (Simplified Chinese)")
    row = ActivityRows.build_rows(aug3 + [moved]).first
    assert_equal ["editions", "3 editions", 4, ""], row.values_at("kind", "tag", "n", "summary")
    assert_equal [["French", [SWITCHER]], ["Persian", [SWITCHER]],
                  ["Simplified Chinese", ["Added the Simplified Chinese translation of the Measuring Mobility lecture.", SWITCHER]]],
                 row["per_edition"].map { |item| item.values_at("lang", "summaries") }
    assert_same row["editions"], row["per_edition"]
    assert_equal %w[#21 #145 #299 #80], row["changes"].map { |change| change["num"] }
  end

  # Edition order differs from project order when one language's name starts another's:
  # "S (Chinese Simplified)" sorts before "S (Chinese)", but "Chinese" before "Chinese Simplified".
  def test_merged_translations_list_their_prs_in_edition_order
    row = ActivityRows.build_rows(
      [translation("2026-10-03", "#{PP} (Chinese Simplified)", "https://example.org/zh-cn/", "B.",
                   [pr("lecture-python-programming.zh-cn", 2, "Second")]),
       translation("2026-10-03", "#{PP} (Chinese)", "https://example.org/zh/", "A.",
                   [pr("lecture-python-programming.zh", 1, "First")])]
    ).first
    assert_equal ["Chinese", "Chinese Simplified"], row["editions"].map { |item| item["lang"] }
    assert_equal %w[#1 #2], row["changes"].map { |change| change["num"] }
  end

  def test_entries_without_summaries
    assert_equal "", ActivityRows.build_rows([lecture("2026-10-01", IQ, IQ_URL)]).first["summary"]
    assert_equal "", ActivityRows.build_rows([release("2026-10-01", "QuantEcon.py", "v1.0.0")]).first["summary"]
    merged = ActivityRows.build_rows([lecture("2026-10-01", IQ, IQ_URL, "Added a lecture."), lecture("2026-10-01", IQ, IQ_URL)])
    assert_equal "Added a lecture.", merged.first["summary"]
    # One distinct summary is shown once, although the Persian edition had none.
    french = translation("2026-10-02", "#{PP} (French)", FR_URL, "A.")
    persian = translation("2026-10-02", "#{PP} (Persian)", FA_URL)
    once = ActivityRows.build_rows([french, persian]).first
    assert_equal "A.", once["summary"]
    assert_nil once["per_edition"]
    # Two distinct summaries: per_edition keeps the Persian edition, with no summaries.
    chinese = translation("2026-10-02", "#{PP} (Simplified Chinese)", "https://example.org/zh-cn/", "B.")
    per = ActivityRows.build_rows([french, persian, chinese]).first
    assert_equal "", per["summary"]
    assert_equal [["French", ["A."]], ["Persian", []], ["Simplified Chinese", ["B."]]],
                 per["per_edition"].map { |item| item.values_at("lang", "summaries") }
    none = ActivityRows.build_rows([persian, persian.merge("project" => "#{PP} (French)")]).first
    assert_equal "", none["summary"]
    assert_nil none["per_edition"]
  end

  def test_book_updates
    rows = ActivityRows.build_rows(busy_day + [book("2026-10-06", "Dynamic Programming", "https://dp.quantecon.org/")])
    books = rows.select { |row| row["type"] == "book" }
    assert_equal [["2026-10-06/book/dynamic-programming", "Book update:", 1], ["2026-10-05/book/dynamic-programming", "Book update:", 2]],
                 books.map { |row| row.values_at("id", "type_word", "n") }
    assert_equal ActivityTestData.ids(books), ActivityTestData.ids(ActivityRows.rail_rows(rows, "book"))
    rail = ActivityRows.rail(rows).flat_map { |week| week["rows"] }
    assert_equal ActivityTestData.ids(books), ActivityTestData.ids(rail.select { |row| row["type"] == "book" })
  end

  def test_an_unknown_type_fails_loudly_and_names_the_file_and_entry
    data = { "2026-10-01-lectures" => [lecture("2026-10-01", IQ, IQ_URL),
                                       entry(Date.new(2026, 10, 1), "podcast", "QuantEcon Podcast", "https://x.org/")] }
    error = assert_raises(ActivityRows::DataError) { ActivityRows.view(data, source: "_data/activity") }
    assert_includes error.message, "_data/activity/2026-10-01-lectures, entry 2 (QuantEcon Podcast)"
    assert_includes error.message, 'unknown type "podcast"'
  end

  def test_malformed_files_and_entries_fail_loudly
    assert_raises(ActivityRows::DataError) { ActivityRows.view({ "a" => { "date" => "2026-10-01" } }) }
    assert_raises(ActivityRows::DataError) { ActivityRows.view({ "a" => ["not a mapping"] }) }
    assert_raises(ActivityRows::DataError) { ActivityRows.view([lecture("2026-10-01", IQ, IQ_URL).merge("changes" => "x")]) }
    assert_raises(ActivityRows::DataError) { ActivityRows.view("not data") }
  end

  def test_empty_or_nil_data_gives_empty_views
    [nil, false, [], {}, { "2026-10-01-lectures" => nil }, { "2026-10-01-lectures" => false },
     { "2026-10-01-lectures" => [] }].each do |data|
      view = ActivityRows.view(data)
      assert_equal %w[rows rail months panel strip first_date first_date_label], view.keys
      %w[rows rail months strip].each { |key| assert_equal [], view[key], "#{key} for #{data.inspect}" }
      assert_nil view["panel"]
      assert_nil view["first_date"]
      assert_nil view["first_date_label"]
    end
    assert_equal [], ActivityRows.build_rows(nil)
    assert_nil ActivityRows.panel_summary([])
    assert_nil ActivityRows.panel_summary(nil)
    assert_equal [], ActivityRows.rail_rows([], "all")
    assert_equal [], ActivityRows.rail([])
    assert_equal [], ActivityRows.by_week([])
    assert_equal [], ActivityRows.by_month([])
  end

  # Summaries and PR titles come from outside the site: the rows return them as given, and
  # the templates escape every field.
  def test_the_escaping_entry_passes_through_unchanged
    tricky = lecture("2026-10-06", %(Tom & Jerry's "Economics" <Beta>), "https://example.org/?a=1&b=<2>",
                     %(Compares <b>bold</b> & "double" and 'single' quotes with `x < y && z`.),
                     [{ "title" => %(Fix <script>alert("x")</script> & `code`), "url" => "https://github.com/QuantEcon/x/pull/7" }])
    row = ActivityRows.build_rows([tricky]).first
    assert_equal [tricky["project"], tricky["url"], tricky["summary"], tricky["changes"].first["title"]],
                 [row["title"], row["url"], row["summary"], row["changes"].first["title"]]
    assert_equal "2026-10-06/lectures/tom-jerry-s-economics-beta", row["id"]
    edition = ActivityRows.build_rows([translation("2026-10-06", %(#{tricky['project']} (<Fr> & "Co")), tricky["url"],
                                                   tricky["summary"])]).first
    assert_equal [tricky["project"], %(<Fr> & "Co"), tricky["summary"]], edition.values_at("title", "tag", "summary")
    single = ActivityRows.build_rows([release("2026-10-06", "A&B <lib>", "v1").merge("summary" => tricky["summary"])]).first
    assert_equal ["A&B <lib>", tricky["summary"]], single.values_at("title", "summary")
    group = ActivityRows.build_rows([release("2026-10-06", "A&B <lib>", "v1"), release("2026-10-06", %(C "q"), "v2")]).first
    assert_equal %(A&B <lib> and C "q"), group["title"]
  end
end

# Rules that stay true as the reporter adds entries to the live data.
class LiveDataTest < Minitest::Test
  include ActivityTestData
  include ActivityAssertions

  def setup
    @data = load_dir(LIVE)
    @view = ActivityRows.view(@data, source: "_data/activity")
    @entries = @data.values.grep(Array).flatten(1)
  end

  def test_the_view_builds_with_every_part
    assert_equal %w[rows rail months panel strip first_date first_date_label], @view.keys
    assert_equal @view["rows"].first(3), @view["strip"]
    assert_equal @entries.empty?, @view["panel"].nil?
  end

  def test_every_entry_lands_in_exactly_one_row
    expected = @entries.group_by { |item| ActivityRows.row_id(item) }.transform_values do |group|
      group.first["type"] == "release" ? group.map { |item| item["url"] }.uniq.size : group.size
    end
    actual = @view["rows"].to_h { |row| [row["id"], row["n"]] }
    assert_equal @view["rows"].size, actual.size, "row ids must be unique"
    assert_equal expected, actual
  end

  def test_days_run_strictly_newest_first
    days = @view["months"].flat_map { |month| month["days"] }.map { |day| day["date"] }
    days.each_cons(2) { |newer, older| assert_operator newer, :>, older }
    assert_equal @view["rows"], @view["months"].flat_map { |month| month["days"] }.flat_map { |day| day["rows"] }
    assert_equal @view["rows"].size, @view["months"].sum { |month| month["row_count"] }
  end

  def test_the_rail_shows_at_most_six_rows_per_filter
    rows = @view["rail"].flat_map { |week| week["rows"] }
    assert_equal ActivityTestData.ids(ActivityRows.rail_rows(@view["rows"])),
                 ActivityTestData.ids(rows.select { |row| row["in_all"] })
    ActivityRows::TYPE_ORDER.each { |type| assert_operator rows.count { |row| row["type"] == type }, :<=, 6 }
  end

  def test_every_key_is_a_string_and_every_value_plain
    assert_plain(@view)
    assert_plain(ActivityRows.view(fixture), "fixture view")
    assert_plain(ActivityRows.view(fixture.merge("busy" => busy_day, "order" => order_day)), "synthetic view")
  end
end
