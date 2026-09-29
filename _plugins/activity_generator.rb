# frozen_string_literal: true

# Computes the Activity rows at build time and exposes them to Liquid as
# site.data.activity_view. The rules are in _plugins/activity/rows.rb, a pure module tested
# by .github/scripts/test-activity.rb; this file only connects them to Jekyll. The data
# format is in README.md ("News and Activity").
#
# The view is built from every file in _data/activity/, ignoring file names and the order
# of entries. Every key is a string, and every value a string, integer, boolean, nil, list
# or hash. Nothing is HTML-escaped: summaries and PR titles come from outside the site, so
# templates escape every field. Dates are "YYYY-MM-DD" strings with precomputed labels:
# compare them as strings, and don't pass them through Liquid's date filters, which work in
# the site's timezone (Australia/Sydney).
#
# site.data.activity_view
#   rows              Every row, newest day first. Within a day: lecture updates, book
#                     updates, translations, then releases; within a type, A to Z by
#                     project (by series for translations).
#   rail              The /news/ rail as rendered: week groups over the latest 6 rows of
#                     each type, each row once. A rail row adds in_all, true when it is among
#                     the 6 newest rows overall (the All view). Filtering these rows by type
#                     gives each filter's latest 6, in order.
#   months            The /activity/ log: month groups, newest first.
#   panel             The mobile panel's summary, or nil when there is no data.
#   strip             The home strip: the 3 newest rows.
#   first_date        The oldest entry's date, "2026-06-12", or nil.
#   first_date_label  "Jun 12, 2026", or nil.
#
# A row
#   id           The row's merge key, stable under any input order and when another
#                same-day entry joins the row: "<date>/release" (a day has one release row,
#                single or group), "<date>/translation/<series-slug>",
#                "<date>/lectures/<project-slug>" or "<date>/book/<project-slug>". Unique;
#                meant as the feed's guid. Not an HTML id.
#   date         "2026-09-27", a UTC calendar day.
#   date_label   "Sep 27".
#   type         lectures | book | translation | release. Also the filter key.
#   kind         single | group (a day's releases) | editions (a series' translations
#                on one day).
#   n            The number of entries merged into the row: 1 for most rows. For an
#                editions row it counts entries, not languages. The copies of one release
#                (the same url on the same day) count once.
#   type_word    The visually hidden word before the title: "Lecture update:",
#                "Book update:", "Translation:", "Translations:", "Release:", "Releases:".
#   title        The project; the series name for translations; "A, B and C" for a
#                release group, each project once.
#   version      A single release's version, else "".
#   url          The release notes or the live site; for group and editions rows, the
#                day on /activity/ ("/activity/#activity-2026-08-02").
#   tag          The language of a single translation; "3 editions" or "1 edition";
#                "4 releases · same day"; else "".
#   summary      Plain text, in which single backticks mark code; else "". A lecture or
#                book row that merges several entries joins their distinct summaries
#                (A to Z, with a space). An editions row has one only when its entries have
#                exactly one distinct summary (entries without one don't count).
#   changes      The PRs, each once: [{title, url, num ("#1070")}]. An editions row lists
#                them in edition order.
#   releases     A release group's releases: [{project, version, url}], A to Z by project
#                and then by version as plain text (v0.7.10 before v0.7.3); else [].
#   editions     An editions row's editions, A to Z by language:
#                [{lang, url, summaries: [...]}]; else [].
#   per_edition  The editions again when the entries have two or more distinct summaries,
#                else nil. An edition in it may have no summaries: skip it in two-line text.
#   in_all       Rail rows only (see rail).
#
# A rail week group
#   start, end   "2026-09-21", "2026-09-27" (Monday to Sunday).
#   label        "Sep 21–27", "Jul 27 – Aug 2" or "Dec 28, 2026 – Jan 3, 2027".
#   datetime     The ISO week, "2026-W39", for <time datetime>.
#   rows         The week's rail rows.
#   has_all      true when a row in the week is in_all.
#
# A month
#   id           "activity-2026-09".
#   label        "September 2026".
#   row_count    Rows in the month.
#   entry_count  Entries merged into those rows.
#   days         [{id ("activity-2026-09-27", the day's anchor), date, rows}], newest first.
#
# The panel
#   entry_count  The entries (not rows) in the calendar month of the newest entry.
#   month        "September".
#   latest       "Sep 27", the newest entry's date; latest_iso "2026-09-27".
#   text         "6 updates in September · latest Sep 27".
#
# Bad data stops the build with a message that names the file and entry: an unknown type,
# a date that isn't a YYYY-MM-DD day, a file that isn't a list, or an entry or change that
# isn't a mapping. So do two series on one day whose names differ only in case or
# punctuation, since their rows would share an id. The message is logged on a line of its
# own, as the build's first error, before Jekyll's backtrace. No data at all gives empty
# lists and nil.
require_relative "activity/rows"

module Jekyll
  class ActivityViewGenerator < Generator
    priority :high

    def generate(site)
      view = ActivityRows.view(site.data["activity"], source: "_data/activity")
      site.data["activity_view"] = view
      Jekyll.logger.debug "Activity:", "#{view['rows'].size} rows in site.data.activity_view"
    rescue ActivityRows::DataError => e
      # The message says what to fix; Jekyll would print it only inside a long backtrace.
      Jekyll.logger.error "Activity data:", e.message.delete_prefix("Activity data: ")
      raise
    end
  end
end
