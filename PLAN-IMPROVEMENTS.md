# QuantEcon Website Maintenance Plan

This document outlines maintenance items and improvements identified during a comprehensive review of the QuantEcon website (December 2024).

---

## Table of Contents
1. [Critical Issues](#critical-issues)
2. [Outdated Content](#outdated-content)
3. [Dead Links & References](#dead-links--references)
4. [Unused/Archive Candidates](#unusedarchive-candidates)
5. [Configuration Improvements](#configuration-improvements)
6. [Content Updates Needed](#content-updates-needed)
7. [Technical Debt](#technical-debt)
8. [Suggested New Content](#suggested-new-content)

---

## Critical Issues

### 1. Dead Discourse Forum References
**Priority: HIGH** ✅ COMPLETED

The Discourse forum (`discourse.quantecon.org`) was closed in March 2025 (per [2025-03-17-discourse-closure.md](pages/../_posts/2025-03-17-discourse-closure.md)), but references still exist in:

- [x] [pages/textbook.md](pages/textbook.md) - Line: "Please direct them to... the Discourse forum"
- [x] [pages/python-developers.md](pages/python-developers.md) - Line: "reach out to the QuantEcon team on the Discourse forum"
- [x] [_includes/quantecon-menubar.html](_includes/quantecon-menubar.html) - Commented out, but Forum link still in code
- [x] [_layouts/default.html](_layouts/default.html) - Commented out discourse icon in navbar

**Action:** ~~Remove or replace all Discourse references with alternative contact methods (email, GitHub Discussions, etc.)~~ DONE

### 2. Outdated RSE Visitor Application Form
**Priority: MEDIUM**

- [ ] [pages/visitor-application.md](pages/visitor-application.md) - Contains a redirect but also has the full form embedded. This page appears to be ANU/RSE specific and may no longer be needed.

**Action:** Verify if this page is still needed. If redirect is working, the full form can be removed.

---

## Outdated Content

### Workshop Pages (Historical) ✅ UPDATED - Linked to GitHub repos

Updated `workshops.md` to link directly to GitHub repositories instead of individual pages.
These individual workshop pages are now orphaned from main navigation but still accessible
via old blog posts and external links:

- [x] [pages/bayesian-workshop-2017.md](pages/bayesian-workshop-2017.md) - NOT linked anywhere - CANDIDATE FOR DELETION
- [x] [pages/econometric-society-workshop.md](pages/econometric-society-workshop.md) - Now orphaned, GitHub link in workshops.md
- [x] [pages/2017-phd-workshops-on-computational-methods.md](pages/2017-phd-workshops-on-computational-methods.md) - Referenced in old blog posts
- [x] [pages/unsw-workshop-2017.md](pages/unsw-workshop-2017.md) - Now orphaned (no GitHub repo available)
- [x] [pages/wams-2017.md](pages/wams-2017.md) - Now orphaned, GitHub link in workshops.md
- [x] [pages/rba-rbnz-workshop.md](pages/rba-rbnz-workshop.md) - Referenced in old blog posts
- [x] [pages/honours-workshop-2018.md](pages/honours-workshop-2018.md) - Now orphaned, GitHub link in workshops.md
- [x] [pages/chicago-fed-workshop.md](pages/chicago-fed-workshop.md) - Now orphaned, GitHub link in workshops.md
- [x] [pages/copenhagen-summer-school-2018.md](pages/copenhagen-summer-school-2018.md) - Now orphaned, GitHub link in workshops.md
- [x] [pages/department-of-industry-innovation-and-science.md](pages/department-of-industry-innovation-and-science.md) - Referenced in old blog post

**Changes made:**
- workshops.md now links to GitHub repos instead of local pages
- Harmonized link format (all say "GitHub repository")
- Removed redundant "Workshop page" + "GitHub repository" dual links

**Future consideration:** Could add redirects from old pages to GitHub repos, or delete pages not referenced elsewhere.

### Outdated Developer/Wiki Pages

- [x] [pages/contribute-lectures.md](pages/contribute-lectures.md) - ~~References Jupinx and RST format~~ UPDATED to Jupyter Book and MyST markdown
- [ ] [pages/wiki.md](pages/wiki.md) - Very sparse, only links to Python instructions
- [ ] [pages/wiki-py-conda-dev-env.md](pages/wiki-py-conda-dev-env.md) - Needs review for current conda practices
- [ ] [pages/wiki-py-docstrings.md](pages/wiki-py-docstrings.md) - May need updates
- [ ] [pages/wiki-py-unit-testing.md](pages/wiki-py-unit-testing.md) - May need updates

**Action:** Review and update developer documentation to reflect current practices.

### Potentially Outdated About Pages

- [ ] [pages/about-python-lectures.md](pages/about-python-lectures.md) - Check if content is current
- [ ] [pages/quantecon-rse-joint-intitiative.md](pages/quantecon-rse-joint-intitiative.md) - Note: filename has typo "intitiative"
- [ ] [pages/department-of-industry-innovation-and-science.md](pages/department-of-industry-innovation-and-science.md) - Government project page, may be historical

---

## Dead Links & References

### External Links to Verify

- [x] `http://notes.quantecon.org/` - ~~Referenced in menubar~~ CLOSED Feb 2025. Menubar updated to GitHub notebook-gallery
- [x] `http://blog.quantecon.org/` - ~~Referenced in menubar~~ Redirects to Medium. Menubar updated to direct Medium link
- [x] `http://cheatsheets.quantecon.org/` - ✅ WORKING
- [ ] `http://store.quantecon.org/` - Verify still working (menubar references)
- [ ] `https://jupinx.quantecon.org/` - Historical (Jupinx replaced by Jupyter Book). Referenced in infrastructure.html and menubar

### Internal Navigation Issues

- [ ] [pages/nb-contrib.md](pages/nb-contrib.md) - References `/notebooks` page which may not exist
- [ ] Menubar has "NB Library" link to `quantecon.org/notebooks` - verify this page exists

---

## Unused/Archive Candidates

### Archive Folder Review

The `/archive` folder contains old versions of pages:
- `archive/datascience.md`
- `archive/julia.md`
- `archive/lectures.md`
- `archive/projects.html` (commented out content)
- `archive/python.md`

**Action:** These appear to be properly archived. No action needed unless cleaning up git history.

### Pages That May Be Redundant

- [ ] [pages/python-lectures.md](pages/python-lectures.md) - Check if needed vs _lectures collection
- [ ] [pages/quantecon-summer-research-student-open-source-soft.md](pages/quantecon-summer-research-student-open-source-soft.md) - Long filename, check if current

---

## Configuration Improvements

### _config.yml Issues ✅ COMPLETED

- [x] `repository:` field is empty - should be set to `QuantEcon/website`
- [x] Collections `news:` is defined but `_news/` folder doesn't exist (posts are in `_posts/`) - REMOVED
- [x] Defaults section has malformed YAML (missing scope dash before second scope) - FIXED

### Gemfile Considerations

- [ ] Jekyll version 4.2.2 is from 2022 - consider updating to latest 4.x
- [ ] Several plugins are commented out (seo-tag, github-pages) - clean up or enable

---

## Content Updates Needed

### Team Members

Review [_team-members/](_team-members/) for:
- [ ] Current roles and positions
- [ ] Active vs former team members
- [ ] Updated photos and links

Current team members listed: 30 profiles

### Lecture Series Descriptions

- [ ] [_lectures/lecture-python.md](_lectures/lecture-python.md) - Description says "second text in the series" - verify accuracy
- [ ] Verify all lecture links are current

### Projects Collection

- [ ] [_projects/python-wasm.md](_projects/python-wasm.md) - Verify QuantEcon.py-wasm project status

### News Posts Review

Very old posts (2014-2016) reference outdated software versions and practices:
- Python 3.5, Julia pre-1.0
- Google Groups (migrated to Discourse, now closed)
- Old website URLs

**Action:** Consider adding a "historical" note to old posts, or display them differently.

---

## Technical Debt

### CSS/SCSS Cleanup

- [ ] Review [assets/sass/]( assets/sass/) for unused styles
- [ ] `_misc.scss` and `_timeline.scss` - verify all styles are used

### JavaScript Review

- [ ] [assets/js/main.js](assets/js/main.js) - Single JS file, review for dead code

### Image Assets

Potentially unused images in [assets/img/](assets/img/):
- [ ] Old workshop photos
- [ ] Team member photos for people no longer listed
- [ ] Various logo versions

**Action:** Audit images against actual usage in HTML/MD files

### HTML in Markdown Files

Several pages use raw HTML in markdown files:
- [pages/workshops.md](pages/workshops.md) - Almost entirely HTML
- [pages/infrastructure.html](pages/infrastructure.html) - Correctly using .html extension
- [pages/visitor-application.md](pages/visitor-application.md) - Complex form HTML

**Action:** Consider converting HTML-heavy .md files to .html for consistency

---

## Suggested New Content

### Missing Pages

- [ ] **Privacy Policy** - No privacy.md found
- [ ] **Terms of Service** - No terms.md found
- [ ] **Accessibility Statement** - Good practice for educational sites

### Documentation Gaps

- [ ] **How to cite QuantEcon** - Currently in about.md but could be expanded
- [ ] **FAQ page** - Common questions about the project
- [ ] **Getting Started Guide** - For new users of QuantEcon resources

### Content Refresh

- [ ] Update homepage sponsor section if new sponsors exist
- [ ] Add recent accomplishments/milestones
- [ ] Consider a "What's New" summary section

---

## Implementation Priority

### Phase 1: Critical Fixes (Do First)
1. Remove/update Discourse forum references
2. Fix _config.yml YAML issues
3. Verify all external links work

### Phase 2: Content Cleanup
1. Archive historical workshop pages
2. Update developer documentation
3. Review team member listings

### Phase 3: Technical Improvements
1. Audit and clean up image assets
2. Review CSS for unused styles
3. Update Jekyll and dependencies

### Phase 4: Enhancements
1. Add privacy/terms pages
2. Create FAQ page
3. Improve contributor documentation

---

## Notes

- The `.github/copilot-instructions.md` is already set up and comprehensive
- Site builds quickly (~1-2 seconds)
- Overall structure is clean and well-organized
- Main concern is outdated content and dead references to discontinued services

---

*Document created: December 2025*
*Last reviewed: December 2025*
