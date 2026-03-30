# website
Website for QuantEcon Organisation
---

## Development

```bash
bundle exec jekyll serve
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