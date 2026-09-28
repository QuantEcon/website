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
| **What goes in** | New projects (a new lecture series, book, a library's first public release, or a new language edition of a lecture series), grants and funding, people (RAs, team changes, open positions), workshops, tutorials and talks, partnerships, and changes that affect users | Every library release; changes to existing lecture series (new lectures, new sections and exercises, substantive revisions, fixes a reader would notice); updates to translated editions |
| **Written by** | A person | The reporter bot (maintained in the private `QuantEcon/reports-activity` repository) |
| **Review** | Normal PR review of the wording | A light check of the reporter's PR |

**Excluded from both:** dependency and action version bumps, CI, build, deploy and publishing-workflow changes, analytics, editor-of-record and other metadata changes, translation-sync tooling, and website changes. Releases of tooling (GitHub Actions, themes, plugins) are not library releases, and a GitHub release published later for an old version is not a new release.

**Promotion is a human decision.** When a release or a batch of lecture changes deserves wider attention, someone writes a News post that links to it.

These definitions decide which stream an item belongs to, not where it is shown. News posts are stored in `_posts/` and Activity entries in `_data/activity/` (schema below). Which pages display each stream is a design choice: today News appears on `/news/`, the home page and `feed.xml`, and Activity on `/activity/`.

### Activity data

Each reporter run adds one file per stream, `_data/activity/<run-date>-<stream>.yml`, holding a list of entries. `<stream>` is `software` for releases and `lectures` for lecture and translation updates, and a run writes no file for a stream with nothing to report. Entry dates can be earlier than the file's run date. The Activity page merges every file, orders the entries by date (newest first, and in file order within a day), and groups them by month. CI checks every file against this schema (`.github/scripts/check-activity-data.rb`).

| Field | Required | Description |
|---|---|---|
| `date` | yes | Unquoted `YYYY-MM-DD`, in UTC. For a `release`, the day it was published. For `lectures` and `translation`, the day of the first `publish-*` release that included every listed change, i.e. when it went live. |
| `type` | yes | `release`, `lectures` or `translation` |
| `project` | yes | Human-readable name, e.g. `QuantEcon.py` or `Intermediate Quantitative Economics with Python`. A translated edition is `<series name> (<language>)`, e.g. `Python Programming for Economics and Finance (French)`. |
| `url` | yes | The release notes (`release`) or the live site (`lectures`, `translation`) |
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

## News Post Tags

Posts in `_posts/` use a `tag` frontmatter field with coloured pill badges on the News page.

| Tag | Colour | Hex |
|---|---|---|
| `news` | Blue | `#0072bc` |
| `lectures` | Dark blue | `#306998` |
| `workshop` | Green | `#6EAC5B` |
| `books` | Red | `#D25663` |
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