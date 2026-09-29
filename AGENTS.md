# AGENTS.md

Guidance for AI coding agents and human contributors working in this repository. This is the canonical guide: tool-specific files (`.github/copilot-instructions.md`) only point here, so edit this file, not them. Where this guide and the code disagree, trust the code and correct the guide in the same pull request.

## Project overview

This is the source of [quantecon.org](https://quantecon.org), the website of QuantEcon, a nonprofit that develops open-source computational tools for economics, econometrics and decision making. The site presents the lecture series, books, code libraries, workshops and team, and two streams of updates: **News**, written by people, and **Activity**, written by a reporter bot.

It is a Jekyll 4.4 static site with a plugin of its own. GitHub Actions deploys `main` to GitHub Pages, and Netlify builds a preview of every pull request. There is no Node.js or JavaScript build step, and no linter or formatter.

[README.md](README.md) is the spec for News and Activity: which stream an item belongs to, the Activity data files and their schema, and how the Activity rows are built. It also lists the News post tags and the brand colours. Read its "News and Activity" section before you change `_posts/`, `_data/activity/`, `_plugins/` or an Activity template.

## Repository layout

| Path | What it holds |
|---|---|
| `_config.yml` | Site settings: `url`, `timezone`, `exclude`, the collections and the front-matter defaults |
| `Gemfile` | Jekyll and its plugins; the site uses no theme. No `Gemfile.lock` is committed, so CI, the deploy and Netlify resolve the newest matching versions on every run. The gitignored `Gemfile.lock` that your first `bundle install` writes keeps your versions until you run `bundle update` |
| `index.md` | The home page's URL and layout, nothing more. `_layouts/home.html` has no `{{ content }}`, so the body of `index.md` is never rendered: edit the home page's sections in that layout |
| `pages/` | Every other page, in Markdown or HTML |
| `_layouts/` | A layout for each kind of page. `default.html` wraps them all, with the header navigation, the footer and the links to CSS and JavaScript |
| `_posts/` | News posts |
| `_data/activity/` | Activity entries, one YAML file per UTC day and stream |
| `_plugins/` | `activity/rows.rb` turns the Activity entries into rows, and `activity_generator.rb` exposes them to Liquid as `site.data.activity_view`. Jekyll runs both on every build |
| `_lectures/`, `_projects/`, `_workshops/`, `_team-members/` | Collections with no pages of their own: layouts and pages list their files |
| `assets/` | `main.scss` (the Sass entry point, which loads `sass/_*.scss` with `@use`), `js/main.js`, `img/` and `downloads/` |
| `feed.xml`, `sitemap.xml` | The RSS feed and the sitemap, both hand-written Liquid templates. The jekyll-feed plugin skips `/feed.xml` because this file exists, so edit the template |
| `.github/workflows/` | `build.yml`, the checks on every pull request, and `deploy.yml`, the GitHub Pages deploy |
| `.github/scripts/` | The Activity data check and two test suites, with a frozen copy of the data in `fixtures/activity/` |
| `archive/` | Retired pages: still published, but nothing links to them |
| `PLAN-IMPROVEMENTS.md` | A maintenance checklist from January 2026, partly out of date |

`_includes/quantecon-menubar.html` is unused: nothing includes it.

## Commands

CI uses Ruby 3.4, and 4.0 works too. Bundler comes with Ruby.

```bash
bundle config set --local path vendor/bundle     # optional: keep the gems in the checkout (gitignored)
bundle install                                   # never with sudo
JEKYLL_ENV=production bundle exec jekyll build   # the build CI runs, into _site/, in about a second
bundle exec jekyll serve                         # http://localhost:4000; --port N to move it
bundle exec jekyll clean                         # delete _site/ and the caches
```

`jekyll serve` rebuilds the site when content, layouts or assets change, but it reads `_config.yml` and loads `_plugins/` only when it starts: restart it after editing either, or it keeps serving the old settings and plugin code.

CI runs these checks before the build. Run them with plain `ruby`, not `bundle exec`: minitest comes with Ruby but isn't in the Gemfile.

```bash
git fetch origin
ruby .github/scripts/check-activity-data.rb --base "$(git merge-base HEAD origin/main)"
ruby .github/scripts/test-check-activity-data.rb   # about 12 seconds; needs git
ruby .github/scripts/test-activity.rb
```

With `--base`, the data check fails on any entry your branch changes, removes or reorders, as it does in CI. Compare with the merge base, not with `origin/main`: once `main` has Activity files that your branch lacks, `--base origin/main` reports them as deleted. Without `--base`, that comparison is skipped.

If a script stops with a `LoadError` (for minitest or mutex_m, say), `GEM_HOME` and `GEM_PATH` probably point at another Ruby's gems, as chruby sets them: run it as `env -u GEM_HOME -u GEM_PATH -u GEM_ROOT ruby …`.

## CI and deployment

`.github/workflows/build.yml` runs one job, `build`, on every pull request to `main`. It is the only required status check: never rename it or split it into several jobs. Its steps, in order:

1. Check out the pull request's merge commit with `fetch-depth: 2`: `HEAD^1` is `main` and `HEAD^2` the pull request's head.
2. **Limit reporter PRs to Activity data**, on pull requests opened by the reporter App (bot user ID 294005175) only, before any code the pull request controls runs. It fails unless the pull request only adds `_data/activity/YYYY-MM-DD-software.yml` or `-lectures.yml` files or appends to them, keeping every existing byte.
3. Set up Ruby 3.4 and install the gems.
4. `ruby .github/scripts/check-activity-data.rb --base HEAD^1`
5. `ruby .github/scripts/test-check-activity-data.rb`, which tests the data check and step 2's script, read from `build.yml`.
6. `ruby .github/scripts/test-activity.rb`
7. `JEKYLL_ENV=production bundle exec jekyll build`, which also fails on Activity data that the rows plugin can't use.

`test-check-activity-data.rb` pins this shape: the job's name, the read-only token, the checkout depth, the guard's position and condition, and the data check's step name and command. Change the workflow, that test and this section together.

`deploy.yml` builds `main` the same way on every push, without the checks, and deploys it to GitHub Pages. Netlify builds each pull request's deploy preview (`netlify.toml`). Dependabot opens weekly pull requests for the gems and the actions.

## Content

To add something, copy the front matter of an existing file of the same kind. The layout that lists those files shows which fields render.

| To add | Create | Notes |
|---|---|---|
| A News post | `_posts/YYYY-MM-DD-slug.md` | Only what README's "News and Activity" puts in News. Set `layout: post`, `title`, `author`, `excerpt` and `tag` (README's "News Post Tags"). Date a post about an event or launch that has happened to that day, and an announcement of something still to come to the day it is published: the build skips a post dated in the future and still passes, and nothing rebuilds the site when that date arrives. Jekyll also skips a file without the `-slug` |
| An Activity entry | `_data/activity/<day>-<stream>.yml` | Written by the reporter bot: see README's "Activity data" for the file names, the schema and the append-only rule |
| A workshop | `_workshops/YYYY-MM-DD-slug.md` | `/workshops/` lists those with `year` 2024 or later as recent, and the home page shows the newest 5 |
| A lecture series | `_lectures/*.md` | `order` sets its place on `/lectures/` and the home page |
| A book or code library | `_projects/*.md` | `type: book` lists it on `/books/` and the home page, in `order`. `type: code` lists it on `/code/`, which ignores `order` and shows code libraries in reverse file-name order. No page shows other types |
| A team member | `_team-members/*.md` | `role` must match one of the section strings in `_layouts/team.html` exactly, or the member is in no section. A `translator` field (such as `"French Editor"`) lists the member under Translators too. A translator with no other role has `role: "Translator"`, which matches no section, and so appears only there. `last_name` sets the order and `tag` adds a badge |
| A page | `pages/*.md` or `pages/*.html` | Set `permalink:`, or the page is published under `/pages/` |
| A redirect | `redirect_from:` in the target page's front matter | As in `pages/activity.md` |

The navigation is in `_layouts/default.html`. Styles go in `assets/main.scss`, which defines the Sass variables in README's "Brand Colours", or in a partial in `assets/sass/` that it loads with `@use`. A partial can't see those variables (the build fails with "Undefined variable"), so use the `--qe-*` custom properties that `main.scss` sets on `:root`, such as `var(--qe-blue)`, as `_about.scss` does.

### News and Activity

- **People write News; the reporter bot writes Activity, and never News.** README's "News and Activity" decides which stream an item belongs to and what belongs in neither. Promoting an Activity item to News is a person's decision.
- **Activity files are append-only.** CI fails a pull request that changes, removes or reorders an entry already on `main`, so a correction to a published entry needs an admin to merge it.
- **Don't edit or add to `.github/scripts/fixtures/activity/`.** It is a frozen copy of the data at 4c47f03, and `test-activity.rb` checks fixed numbers against it. To see the Activity pages with that data, build a copy of the site with `_data/activity/` replaced by the fixture.
- **Build Activity views from `site.data.activity_view`,** not from `site.data.activity`. The header comment of `_plugins/activity_generator.rb` documents every key and field. In the templates:
  - Escape every field, attributes included: nothing in the view is escaped, and summaries and PR titles come from outside the site. Turn backtick spans into `<code>` after escaping.
  - Dates are `YYYY-MM-DD` strings for UTC days, with precomputed labels. Compare them as strings, and never pass them through Liquid's `date` filter, which works in Sydney time.
  - A row's `id` is its merge key and feed guid, not an HTML id. Render the month and day anchors (`months[].id` and `months[].days[].id`): group and editions rows link to a day's anchor.
- **A build that stops with `Activity data: <file>, entry <n> (<project>): …`** names the entry that the rows plugin can't use, with `<file>` missing its `.yml`. Correct the entry, then run the data check.

## Gotchas

- **Root files are published.** Jekyll publishes every file that `exclude:` in `_config.yml` doesn't list and whose name doesn't start with `_` or `.`, and it copies files without front matter as they are: `README.md` and `netlify.toml` are on quantecon.org. Add any new root file that isn't part of the site to `exclude:`, as `AGENTS.md` is.
- **`url` is load-bearing.** `url: "https://quantecon.org"` in `_config.yml` makes og:url, share links, the feed, the sitemap and the redirect stubs absolute, and the Actions build doesn't set it for you. `jekyll serve` swaps in `http://localhost:4000`, so check absolute URLs in a `jekyll build`. Netlify previews keep the production `url`, so their absolute links and redirects lead to quantecon.org.
- **Sydney time.** `timezone: Australia/Sydney` sets `TZ` for every build, CI included, so `site.time` and post dates are Sydney times. A `date:` with another UTC offset can move a post to another day, and so to another URL.
- **Defaults.** Every file gets `layout: default` unless it sets a layout, so a post needs `layout: post`. A lecture or book without `order` sorts last (99).
- **Analytics everywhere.** The Google Analytics tag is on every page in every environment, local builds and previews included.
- **CDNs.** Bootstrap 5.2, Bootstrap Icons and MathJax 3 load from jsDelivr, the fonts from Google Fonts, and Plotly on the analytics dashboard. Where the network is blocked, pages render unstyled and log console errors that aren't the site's.
- **Keep `jekyll serve` local.** `jekyll serve --host 0.0.0.0` exposes the server to the network and sets `site.url` to `http://0.0.0.0:4000`. Use it only inside a container.

## Pull requests and commits

- Work on a branch and open a pull request to `main`. Pull requests are squash-merged: the commit on `main` takes the pull request's title plus `(#N)` as its subject and every commit message on the branch as its body, so write each commit message for `main`.
- Subjects read `area: lower-case summary`, with areas such as `activity`, `news`, `team`, `books`, `ci`, `docs`, `a11y` and `perf`.
- Commit messages refer to an issue with `Part of #N.` Only the pull request's body closes one (`Closes #N.`).
- Never put a closing keyword (close, fix or resolve in any form, even as a noun, as in "the fix:") directly before any other issue or pull request reference, or before any reference to another repository: GitHub closes the target when the text reaches `main`.
- In pull request bodies, issues and comments, write each paragraph as one line, since GitHub turns single newlines into line breaks. Keep prose out of fenced code blocks: use lists and tables, and keep fences for commands and code.
- `build` must pass. Check the change on the pull request's Netlify deploy preview too.
