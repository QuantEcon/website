# website
Website for QuantEcon Organisation
---

## Development

```bash
bundle exec jekyll serve
```

## News and Activity

The site has two streams of updates. The rule of thumb: **people write News, the reporter bot writes Activity.** The bot never publishes to News.

| | News | Activity |
|---|---|---|
| **What goes in** | New projects (a new lecture series, book, a library's first public release, or a new language edition of a lecture series), grants and funding, people (RAs, team changes, open positions), workshops, tutorials and talks, partnerships, and changes that affect users | Every library release; changes to existing lecture series (new lectures, new sections and exercises, substantive revisions, fixes a reader would notice); updates to translated editions; updates to existing books |
| **Written by** | A person | The reporter bot (maintained in the private `QuantEcon/reports-activity` repository) |
| **Review** | Normal PR review of the wording | None day to day: the reporter's daily PR merges itself once the data check passes (planned; until then, a light check of each PR) |

**Excluded from both:** dependency and action version bumps, CI, build, deploy and publishing-workflow changes, analytics, editor-of-record and other metadata changes, translation-sync tooling, and website changes. Releases of tooling (GitHub Actions, themes, plugins) are not library releases, and a GitHub release published later for an old version is not a new release.

**Promotion is a human decision.** When a release or a batch of lecture changes deserves wider attention, someone writes a News post that links to it.

These definitions decide which stream an item belongs to, not where it is shown. News posts are stored in `_posts/` and Activity entries in `_data/activity/` (schema below). Which pages display each stream is a design choice: today News appears on `/news/`, the home page and `feed.xml`, and Activity on `/activity/`.

### Activity data

Each file is `_data/activity/<day>-<stream>.yml` and holds a list of entries. `<day>` is the UTC day the entries cover, not the day the reporter ran, and `<stream>` is `software` for releases and `lectures` for lecture, translation and book updates. A run writes no file for a stream with nothing to report. Files are append-only: a re-run adds its new entries after the existing ones and never changes or removes one. It appends them as text after the file's last byte, with no `---` line: re-dumping the whole file would drop its header comment, and Jekyll reads only a file's first YAML document. Older files, migrated from the previous reporter or added by hand (`2026-09-28-software.yml`), are named for the day they were written, so their entries can be earlier. The Activity page shows the rows that the plugin builds from every file (see "Activity rows"), by month and day, newest first. CI checks every file against this schema (`.github/scripts/check-activity-data.rb`), and fails if `_data/activity/` holds anything but `.yml` and `.yaml` files or a file holds more than one YAML document. It also fails when a release or pull-request URL is listed more than once, in one file or across files, and when a pull request changes or removes an entry that is already on `main`, so a correction to a published entry needs an admin to merge it. A pull request opened by the reporter bot also fails CI unless all it does is add day files or append to them, keeping every existing byte as it is (the first step after checkout in `.github/workflows/build.yml`).

| Field | Required | Description |
|---|---|---|
| `date` | yes | Unquoted `YYYY-MM-DD`, in UTC. For a `release`, the day it was published. For `lectures`, `translation` and `book`, the day of the first `publish-*` release that included every listed change, i.e. when it went live. |
| `type` | yes | `release`, `lectures`, `translation` or `book` |
| `project` | yes | Human-readable name, e.g. `QuantEcon.py` or `Intermediate Quantitative Economics with Python`. A translated edition is `<series name> (<language>)`, e.g. `Python Programming for Economics and Finance (French)`. |
| `url` | yes | The release notes (`release`) or the live site (`lectures`, `translation`, `book`) |
| `version` | `release` only | The released version tag, as a string, e.g. `v0.12.0` (quote numeric-looking versions such as `"1.10"`) |
| `summary` | no | One factual sentence describing what changed. Plain text, except that text in single backticks renders as inline code. |
| `changes` | no | List of `{title, url}` links to the pull requests behind the entry (GitHub pull-request URLs), merged into the default branch. Titles are plain text, lightly tidied: prefixes such as `[slug]`, `FIX:` or `chore:`, and internal notes, may be dropped. |

For example, `_data/activity/2026-09-27-lectures.yml`:

```yaml
- date: 2026-09-27
  type: lectures
  project: Intermediate Quantitative Economics with Python
  url: https://python.quantecon.org/
  summary: Added three new lectures (Linear Quadratic Mean Field Games, Investment Under Uncertainty, and Optimal Growth Under Uncertainty and Tobin's q), and added exercises to the two auction lectures.
  changes:
  - title: Two sequels to rational_expectations
    url: https://github.com/QuantEcon/lecture-python.myst/pull/1070
  - title: Add exercises and further reading
    url: https://github.com/QuantEcon/lecture-python.myst/pull/1069
  - title: Add VCG comparison section and exercises
    url: https://github.com/QuantEcon/lecture-python.myst/pull/1068
```

and `_data/activity/2026-09-24-software.yml`:

```yaml
- date: 2026-09-24
  type: release
  project: QuantEcon.py
  version: v0.12.0
  url: https://github.com/QuantEcon/QuantEcon.py/releases/tag/v0.12.0
```

### Activity rows

At build time, a plugin turns the entries into the rows that the Activity views show, and exposes them to Liquid as `site.data.activity_view`. The rules are in `_plugins/activity/rows.rb`, and `_plugins/activity_generator.rb` connects them to Jekyll. The view holds every row, the `/news/` rail's rows grouped by week, the `/activity/` log's months and days, the mobile panel's summary, the home strip's rows and the log's first date. The generator's header comment lists every key and field.

- **Order.** File names and the order of entries don't matter. Days run newest first. Within a day come lecture updates, then book updates, then translations, then releases, each A to Z by project.
- **Merges.** A day's releases form one row. A series' translations on one day form one row that lists the editions. A lecture series or book that published twice in a day forms one ordinary row. Each row has a stable `id` built from what it merges on, such as `2026-08-02/release` or `2026-09-27/lectures/intermediate-quantitative-economics-with-python`.
- **Dates** are calendar days. The plugin computes every label ("Sep 27", "Sep 21–27", `2026-W39`, "September 2026"), so templates don't need Liquid's date filters, which work in the site's Sydney timezone.

Run the tests with `ruby .github/scripts/test-activity.rb`; CI runs them after the data check. They check fixed numbers against a frozen copy of the data in `.github/scripts/fixtures/activity/` (the 40 entries at commit 4c47f03, which must not change). On the live data they check only rules that stay true as entries are added. To see the pages with the frozen data, build a copy of the site with `_data/activity/` replaced by the fixture.

## News Post Tags

Posts in `_posts/` use a `tag` frontmatter field with coloured pill badges on the News page.

| Tag | Colour | Hex |
|---|---|---|
| `news` | Blue | `#0072bc` |
| `lectures` | Dark blue | `#306998` |
| `workshop` | Green | `#4a7c3c` |
| `books` | Red | `#b83d4b` |
| `tools` | Yellow | `#FCC837` |
| `announcement` | Dark grey | `#283039` |

Usage in post frontmatter:

```yaml
---
layout: post
title: "Post Title"
author: QuantEcon
excerpt: Short description for the news listing card.
tag: [lectures]
---
```

## Brand Colours

| Name | Variable | Hex |
|---|---|---|
| Blue | `$qe-blue` | `#1364AC` |
| Red | `$qe-red` | `#D25663` |
| Green | `$qe-green` | `#6EAC5B` |
| Yellow | `$qe-yellow` | `#FCC837` |
| Link | `$color-link` | `#0072bc` |
| Dark | `$color-dark` | `#283039` |
| Light | `$color-light` | `#f8f9fc` |
| Border | `$color-border` | `#e2e8f0` |