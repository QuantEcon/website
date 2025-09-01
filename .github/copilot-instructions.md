# QuantEcon Website

The QuantEcon website is a Jekyll-based static site that serves as the main portal for QuantEcon, a nonprofit organization providing open source computational tools for economics, econometrics, and decision making.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Bootstrap and Build the Repository

Install bundler and set up the development environment:
- `gem install bundler --user-install` - Install bundler locally (required for Jekyll)
- `export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"` - Add bundler to PATH
- `bundle config set --local path 'vendor/bundle'` - Configure local gem installation path
- `bundle install` - Install Jekyll dependencies (takes ~30 seconds)

Build the static site:
- `bundle exec jekyll build` - Build the site (takes ~1-2 seconds). **NEVER CANCEL**: Fast build, 5 second timeout is sufficient.
- Output goes to `_site/` directory

### Development Server

Run the Jekyll development server:
- `bundle exec jekyll serve --host 0.0.0.0 --port 4000` - Start development server (takes ~2 seconds to start)
- Access the site at `http://localhost:4000`
- **NEVER CANCEL**: Server startup is fast, but may run indefinitely for development
- Use `Ctrl+C` to stop the server when done

### Repository Structure

Key directories and files:
- `_config.yml` - Jekyll configuration file
- `Gemfile` - Ruby dependencies specification
- `_layouts/` - Jekyll layout templates (home.html, default.html, post.html, etc.)
- `_includes/` - Jekyll include templates (quantecon-menubar.html)
- `_posts/` - Blog posts and news articles (sorted chronologically)
- `_lectures/` - Collection of lecture series pages
- `_projects/` - Collection of project pages  
- `_team-members/` - Collection of team member profiles
- `pages/` - Static pages (about.md, lectures.md, workshops.md, etc.)
- `assets/` - Static assets (images, CSS, JavaScript)
  - `assets/js/main.js` - Main JavaScript file
  - `assets/sass/` - SCSS stylesheets
  - `assets/img/` - Images and graphics
- `_site/` - Generated static site (excluded from git)
- `vendor/` - Bundler gems (excluded from git)

### Common Operations

**Adding new content:**
- Blog posts: Add markdown files to `_posts/` with format `YYYY-MM-DD-title.md`
- Team members: Add markdown files to `_team-members/` 
- Lectures: Add markdown files to `_lectures/`
- Static pages: Add markdown files to `pages/`

**Editing existing content:**
- All content uses markdown with Jekyll front matter
- Edit the appropriate markdown file in the relevant directory
- Run `bundle exec jekyll build` to regenerate the site
- Test changes with `bundle exec jekyll serve`

## Validation

**Always validate changes by testing complete user scenarios:**
1. Build the site: `bundle exec jekyll build`
2. Start the development server: `bundle exec jekyll serve --host 0.0.0.0 --port 4000`
3. Open browser to `http://localhost:4000`
4. Navigate through the main sections:
   - Home page - verify layout and content load
   - Lectures page - verify lecture series are listed
   - News page - verify blog posts display
   - About page - verify team information
   - Navigation menu - verify all links work
5. Test responsive design by resizing browser window
6. Verify images and styling load correctly

**No formal testing infrastructure exists** - validation is done through manual browser testing.

**No linting or formatting commands** - the repository has minimal tooling beyond Jekyll itself.

## Dependencies and Requirements

**Ruby Environment:**
- Ruby 3.2+ (3.2.3 confirmed working)
- Bundler gem manager
- Jekyll 4.2.2 (specified in Gemfile)

**Key Jekyll plugins used:**
- jekyll-feed - RSS feed generation
- jekyll-redirect-from - URL redirects
- minima - Base theme
- webrick - Development server

**No Node.js, npm, or JavaScript build tools required** - this is a pure Jekyll/Ruby environment.

## Troubleshooting

**Permission errors during bundle install:**
- Use `bundle config set --local path 'vendor/bundle'` to install gems locally
- Never use `sudo` with gem commands

**Build failures:**
- Check that Ruby 3.2+ is installed
- Verify all dependencies installed with `bundle install`
- Clear cache with `bundle exec jekyll clean` before rebuilding

**Server access issues:**
- Ensure server is bound to `0.0.0.0` not just `127.0.0.1`
- Check port 4000 is not in use by another process
- Access via `http://localhost:4000` not `0.0.0.0`

## Important Information

**Build times:**
- Bundle install: ~30 seconds
- Jekyll build: 1-2 seconds (very fast)
- Server startup: ~2 seconds

**Git workflow:**
- `vendor/` and `.bundle/` directories are gitignored (contain local gems)
- `_site/` directory is gitignored (contains generated output)
- Only source files should be committed

**External dependencies:**
- Site loads external JavaScript libraries from CDNs (Bootstrap, AOS, Swiper, etc.)
- Some JavaScript errors may appear in browser console due to blocked CDN requests in development environments
- These errors don't affect core site functionality

## Common Tasks Reference

### Frequently used commands
```bash
# Setup (run once after clone)
gem install bundler --user-install
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"
bundle config set --local path 'vendor/bundle'
bundle install

# Development workflow
bundle exec jekyll build
bundle exec jekyll serve --host 0.0.0.0 --port 4000

# Clean build (if needed)
bundle exec jekyll clean
bundle exec jekyll build
```

### Repository root listing
```
├── .gitignore
├── .prettierignore  
├── CNAME
├── Gemfile
├── README.md
├── _config.yml
├── _includes/
├── _layouts/
├── _lectures/
├── _posts/ 
├── _projects/
├── _team-members/
├── archive/
├── assets/
├── feed.xml
├── index.md
├── pages/
└── sitemap.xml
```

### Key files content

**Gemfile dependencies:**
- jekyll ~> 4.2.2
- minima ~> 2.5
- jekyll-feed ~> 0.12
- jekyll-redirect-from
- webrick ~> 1.8

**_config.yml key settings:**
- Site title: QuantEcon
- Timezone: Australia/Sydney
- Collections: news, lectures, projects, team-members
- Plugins: jekyll-redirect-from