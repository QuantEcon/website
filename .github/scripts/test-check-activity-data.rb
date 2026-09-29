# frozen_string_literal: true

# Tests for check-activity-data.rb, and for build.yml's limit on the reporter
# App's pull requests. Run from anywhere with plain Ruby (CI's build job runs it):
#
#   ruby .github/scripts/test-check-activity-data.rb
#
# The pull-request cases build real merge commits, clone them at depth 2 the way
# actions/checkout does, and run what CI runs there: the guard step's script, read
# from build.yml, and the data check with the workflow's own arguments.
require "date"
require "fileutils"
require "minitest/autorun"
require "open3"
require "rbconfig"
require "shellwords"
require "tmpdir"
require "yaml"

REPO = File.expand_path("../..", __dir__)
CHECK_SCRIPT = ".github/scripts/check-activity-data.rb"
WORKFLOW = YAML.safe_load(File.read(File.join(REPO, ".github/workflows/build.yml")))
STEPS = WORKFLOW.dig("jobs", "build", "steps")
BOT_USER_ID = 294005175

# git runs with a fixed identity and without the user's or the system's config.
GIT_ENV = {
  "GIT_AUTHOR_NAME" => "Activity Test", "GIT_AUTHOR_EMAIL" => "activity-test@example.com",
  "GIT_COMMITTER_NAME" => "Activity Test", "GIT_COMMITTER_EMAIL" => "activity-test@example.com",
  "GIT_CONFIG_NOSYSTEM" => "1", "GIT_CONFIG_GLOBAL" => File::NULL, "GIT_TERMINAL_PROMPT" => "0",
  # A site directory must not be taken for part of a repository above the temporary directory.
  "GIT_CEILING_DIRECTORIES" => File.realpath(Dir.tmpdir)
}.freeze

HEADER = "# Activity data: see \"News and Activity\" in README.md for the schema.\n\n"
SOFTWARE = "_data/activity/2026-09-24-software.yml"
LECTURES = "_data/activity/2026-09-27-lectures.yml"
NEW_DAY = "_data/activity/2026-09-30-software.yml"
FUTURE_DAY = "_data/activity/2099-12-31-software.yml" # far enough ahead to miss the real data

def release(date, project, version, owner: "QuantEcon", summary: nil)
  yaml = <<~YAML
    - date: #{date}
      type: release
      project: #{project}
      version: #{version}
      url: https://github.com/#{owner}/#{project}/releases/tag/#{version}
  YAML
  summary ? "#{yaml}  summary: #{summary}\n" : yaml
end

def lectures(date, summary, pulls, type: "lectures", project: "Intermediate Quantitative Economics with Python",
             url: "https://python.quantecon.org/")
  changes = pulls.map { |title, pull| "  - title: #{title}\n    url: #{pull}\n" }.join
  "- date: #{date}\n  type: #{type}\n  project: #{project}\n  url: #{url}\n  summary: #{summary}\n  changes:\n#{changes}"
end

PULL_1070 = "https://github.com/QuantEcon/lecture-python.myst/pull/1070"
PULL_1069 = "https://github.com/QuantEcon/lecture-python.myst/pull/1069"
TRANSLATION = lectures("2026-09-27", "Synced the French edition with the English source.",
                       [["Sync translations from lecture-python-programming",
                         "https://github.com/QuantEcon/lecture-python-programming.fr/pull/12"]],
                       type: "translation", project: "Python Programming for Economics and Finance (French)",
                       url: "https://quantecon.github.io/lecture-python-programming.fr/")
LECTURE_UPDATE = lectures("2026-09-27", "Added two lectures on rational expectations.",
                          [["Two sequels to rational_expectations", PULL_1070],
                           ["Add exercises and further reading", PULL_1069]])
# The first file git lists holds multi-byte text, so reading the base has to count
# bytes, not characters, to find the next file.
BASE_DATA = {
  SOFTWARE => HEADER + release("2026-09-24", "QuantEcon.py", "v0.12.0",
                               summary: "Speeds up “simulate” — Tobin’s q examples run faster."),
  LECTURES => HEADER + LECTURE_UPDATE + TRANSLATION
}.freeze
SITE_FILES = {
  "Gemfile" => "source \"https://rubygems.org\"\ngem \"jekyll\", \"~> 4.4\"\n",
  "_layouts/activity.html" => "<div class=\"activity-feed\"></div>\n"
}.freeze
BOOK = <<~YAML
  - date: 2026-09-30
    type: book
    project: Dynamic Programming
    url: https://dp.quantecon.org/
    summary: Added exercises to chapter 3.
    changes:
    - title: Add chapter 3 exercises
      url: https://github.com/QuantEcon/book-dp-public/pull/40
YAML

module ActivityTestHelpers
  def setup
    @tmp = Dir.mktmpdir("activity-test")
  end

  def teardown
    FileUtils.rm_rf(@tmp)
  end

  def write_files(root, files)
    files.each do |path, content|
      full = File.join(root, path)
      FileUtils.mkdir_p(File.dirname(full))
      File.write(full, content)
    end
  end

  def git(*args, chdir: @tmp)
    out, status = Open3.capture2e(GIT_ENV, "git", *args, chdir: chdir)
    assert status.success?, "git #{args.join(' ')} failed:\n#{out}"
    out
  end

  # A directory laid out like the repository, holding the data check and `files`.
  def site(files, name: "site")
    root = File.join(@tmp, name)
    write_files(root, files)
    FileUtils.mkdir_p(File.join(root, File.dirname(CHECK_SCRIPT)))
    FileUtils.cp(File.join(REPO, CHECK_SCRIPT), File.join(root, CHECK_SCRIPT))
    root
  end

  def run_check(root, *args)
    out, status = Open3.capture2e(GIT_ENV, RbConfig.ruby, CHECK_SCRIPT, *args, chdir: root)
    [out, status.success?]
  end

  # The data check exactly as the workflow's "Check Activity data" step runs it.
  def run_workflow_check(work)
    words = Shellwords.split(STEPS.find { |step| step["name"] == "Check Activity data" }.fetch("run"))
    assert_equal ["ruby", CHECK_SCRIPT], words.first(2)
    run_check(work, *words.drop(2))
  end

  # The guard step's own script, run the way Actions runs a `shell: bash` step.
  def run_guard(work)
    script = File.join(@tmp, "guard.sh")
    File.write(script, guard_step.fetch("run"))
    out, status = Open3.capture2e(GIT_ENV, "bash", "--noprofile", "--norc", "-eo", "pipefail", script, chdir: work)
    [out, status.success?]
  end

  def guard_step
    STEPS.find { |step| step["if"].to_s.include?(BOT_USER_ID.to_s) } or
      flunk "build.yml has no step keyed on the reporter's bot user ID (#{BOT_USER_ID})"
  end

  # A repository whose main holds `base`, with a pull request branch changed by the
  # block (it gets the origin's path and edits the working tree) and the test merge
  # commit GitHub makes, as refs/pull/1/merge. `main_later` lands on main after the
  # branch is made. Returns a checkout of the merge commit, made like
  # actions/checkout's: fetch at the given depth, then check out detached.
  def pull_request(base: BASE_DATA, main_later: nil, depth: 2, checkout: "refs/pull/1/merge")
    origin = File.join(@tmp, "origin")
    FileUtils.mkdir_p(origin)
    git("init", "-q", "-b", "main", chdir: origin)
    write_files(origin, SITE_FILES.merge(CHECK_SCRIPT => File.read(File.join(REPO, CHECK_SCRIPT))).merge(base))
    git("add", "-A", chdir: origin)
    git("commit", "-q", "-m", "main", chdir: origin)
    git("checkout", "-q", "-b", "pr", chdir: origin)
    yield origin if block_given?
    git("add", "-A", chdir: origin)
    git("commit", "-q", "--allow-empty", "-m", "pull request", chdir: origin)
    git("checkout", "-q", "main", chdir: origin)
    if main_later
      write_files(origin, main_later)
      git("add", "-A", chdir: origin)
      git("commit", "-q", "-m", "main moves on", chdir: origin)
    end
    git("checkout", "-q", "--detach", "main", chdir: origin)
    git("merge", "-q", "--no-ff", "--no-edit", "pr", chdir: origin)
    git("update-ref", "refs/pull/1/merge", "HEAD", chdir: origin)
    git("checkout", "-q", "main", chdir: origin)

    work = File.join(@tmp, "work")
    git("init", "-q", "-b", "main", work)
    git("remote", "add", "origin", "file://#{origin}", chdir: work)
    git("fetch", "-q", "--no-tags", "--prune", "--no-recurse-submodules", "--depth=#{depth}", "origin",
        "+#{checkout}:refs/remotes/pull/1/merge", chdir: work)
    git("checkout", "-q", "--force", "refs/remotes/pull/1/merge", chdir: work)
    work
  end

  def append(origin, path, text)
    File.write(File.join(origin, path), text, mode: "a")
  end

  def edit(origin, path)
    full = File.join(origin, path)
    File.write(full, yield(File.read(full)))
  end
end

class CheckActivityDataTest < Minitest::Test
  include ActivityTestHelpers

  def test_the_repository_data_passes
    files = Dir.glob(File.join(REPO, "_data/activity/*.{yml,yaml}")).to_h do |path|
      ["_data/activity/#{File.basename(path)}", File.read(path)]
    end
    refute_empty files
    out, ok = run_check(site(files))
    assert ok, out
    assert_includes out, "Activity data OK (#{files.size} files)"
    assert_includes out, "No --base given, so the check that existing entries are unchanged was skipped"

    # The same data as a pull request's base, with a new day added on the branch.
    entries = files.values.sum { |yaml| YAML.safe_load(yaml, permitted_classes: [Date]).size }
    work = pull_request(base: files) do |origin|
      write_files(origin, FUTURE_DAY => release("2099-12-31", "ActivityTest.jl", "v0.0.1"))
    end
    out, ok = run_workflow_check(work)
    assert ok, out
    assert_includes out, "the #{entries} entries in its #{files.size} files are unchanged"
    assert_includes out, "Activity data OK (#{files.size + 1} files)"
  end

  def test_a_book_entry_passes
    out, ok = run_check(site(BASE_DATA.merge("_data/activity/2026-09-30-lectures.yml" => BOOK)))
    assert ok, out
    assert_includes out, "Activity data OK (3 files)"
  end

  def test_an_unknown_type_fails_naming_the_file_and_entry
    out, ok = run_check(site({ NEW_DAY => BOOK.sub("type: book", "type: books") }))
    refute ok
    assert_includes out, "::error::#{NEW_DAY}, entry 1: type must be one of release, lectures, translation, book"
  end

  def test_a_release_listed_in_two_files_fails_naming_both
    new_day = release("2026-09-30", "QuantEcon.jl", "v0.17.0") + release("2026-09-24", "QuantEcon.py", "v0.12.0")
    out, ok = run_check(site(BASE_DATA.merge(NEW_DAY => new_day)))
    refute ok
    assert_includes out, "::error::Release https://github.com/QuantEcon/QuantEcon.py/releases/tag/v0.12.0 is listed 2 times: " \
                         "#{SOFTWARE}, entry 1; #{NEW_DAY}, entry 2. List it once."
  end

  def test_a_pull_request_listed_in_two_files_fails_naming_both
    other = "_data/activity/2026-09-30-lectures.yml"
    again = lectures("2026-09-30", "Revised a lecture.", [["Same PR", PULL_1069]])
    out, ok = run_check(site(BASE_DATA.merge(other => again)))
    refute ok
    assert_includes out, "::error::Pull request #{PULL_1069} is listed 2 times: " \
                         "#{LECTURES}, entry 1, change 2; #{other}, entry 1, change 1. List it once."
  end

  def test_duplicates_within_one_file_fail
    twice = release("2026-09-24", "QuantEcon.py", "v0.12.0")
    same_pull = lectures("2026-09-27", "Revised a lecture.", [["First", PULL_1070], ["Again", PULL_1070]])
    out, ok = run_check(site({ SOFTWARE => twice + twice, LECTURES => same_pull }))
    refute ok
    assert_includes out, "is listed 2 times: #{SOFTWARE}, entry 1; #{SOFTWARE}, entry 2."
    assert_includes out, "is listed 2 times: #{LECTURES}, entry 1, change 1; #{LECTURES}, entry 1, change 2."
  end

  def test_urls_that_differ_only_in_owner_or_repository_case_are_duplicates
    lower = release("2026-09-30", "quantecon.py", "v0.12.0", owner: "quantecon")
    out, ok = run_check(site(BASE_DATA.merge(NEW_DAY => lower)))
    refute ok
    assert_includes out, "::error::Release https://github.com/QuantEcon/QuantEcon.py/releases/tag/v0.12.0 (also written " \
                         "https://github.com/quantecon/quantecon.py/releases/tag/v0.12.0) is listed 2 times: " \
                         "#{SOFTWARE}, entry 1; #{NEW_DAY}, entry 1. List it once."
  end

  def test_the_existing_rules_still_apply
    entry = release("2026-09-30", "QuantEcon.jl", "v0.17.0")
    {
      "[]\n" => "must be a non-empty list of entries",
      "- date: [\n" => "invalid YAML",
      "- just text\n" => "entry 1: must be a mapping",
      entry.sub("  project: QuantEcon.jl\n", "") => "entry 1: missing project",
      entry.sub("date: 2026-09-30", "date: \"2026-09-30\"") => "entry 1: date must be an unquoted YYYY-MM-DD date",
      entry.sub("url: https://", "url: http://") => "entry 1: url must start with https://",
      entry.sub("version: v0.17.0", "version: 1.10") => "entry 1: release entries need a version, written as a string",
      TRANSLATION.sub(" (French)", "") => "a translation's project must be \"<series name> (<language>)\"",
      lectures("2026-09-30", "Uses `code", [["A", PULL_1070]]) => "entry 1: summary has an unmatched or doubled backtick",
      lectures("2026-09-30", "''", [["A", PULL_1070]]) => "entry 1: summary must be a non-empty string",
      lectures("2026-09-30", "Revised.", []).sub("  changes:\n", "  changes: []\n") => "changes must not be an empty list",
      lectures("2026-09-30", "Revised.", [["A", "https://github.com/QuantEcon/x/issues/3"]]) =>
        "entry 1, change 1: needs a string title and a GitHub pull-request url"
    }.each_with_index do |(yaml, message), i|
      out, ok = run_check(site({ NEW_DAY => yaml }, name: "site-#{i}"))
      refute ok, "expected a failure for:\n#{yaml}"
      assert_includes out, "::error::#{NEW_DAY}"
      assert_includes out, message
    end
  end

  def test_a_file_must_be_one_yaml_document
    entry = release("2026-09-30", "QuantEcon.jl", "v0.17.0")
    {
      "---\n#{entry}" => true, # one document may start with ---
      "#{entry}...\n" => true, # and end with ...
      "#{entry}---\n#{release('2026-09-24', 'QuantEcon.py', 'v0.12.0')}" => false,
      "#{entry}...\n--- !ruby/object:Gem::Installer\ni: x\n" => false
    }.each_with_index do |(yaml, passes), i|
      out, ok = run_check(site(BASE_DATA.merge(NEW_DAY => yaml), name: "site-#{i}"))
      if passes
        assert ok, out
      else
        refute ok, "expected a failure for:\n#{yaml}"
        assert_includes out, "::error::#{NEW_DAY}: holds 2 YAML documents, but Jekyll reads only the first."
        assert_equal 1, out.scan(/^::error::/).size, out
      end
    end
  end

  def test_only_yaml_files_may_be_in_the_data_directory
    entry = release("2026-09-30", "QuantEcon.jl", "v0.17.0")
    json = '[{"date":"2026-09-30","type":"nonsense","project":"Unchecked","url":"http://example.com/"}]'
    root = site(BASE_DATA.merge(
      "_data/activity/2026-09-30-extra.json" => json,
      "_data/activity/2026-09-30-software.yml.json" => json,
      "_data/activity/2026-09-30-lectures.csv" => "date,type\n2026-09-30,nonsense\n",
      "_data/activity/sub/2026-09-30-software.yml" => entry,
      "_data/activity/2026-09-30-software.yml/2026-09-30-software.yml" => entry,
      "_data/activity/.DS_Store" => "skipped, like every name that starts with a dot, as Jekyll does"
    ))
    File.symlink("nowhere.yml", File.join(root, "_data/activity/2026-09-30-lectures.yml"))
    out, ok = run_check(root)
    refute ok
    %w[2026-09-30-extra.json 2026-09-30-lectures.csv 2026-09-30-software.yml.json].each do |name|
      assert_includes out, "::error::_data/activity/#{name}: not a .yml or .yaml file. " \
                           "_data/activity/ may hold only .yml and .yaml files, the only ones this check reads"
    end
    %w[2026-09-30-software.yml sub].each do |name|
      assert_includes out, "::error::_data/activity/#{name}: a directory."
    end
    assert_includes out, "::error::_data/activity/2026-09-30-lectures.yml: not a regular file."
    assert_equal 6, out.scan(/^::error::/).size, out

    out, ok = run_check(site({ "_data/activity/notes.txt" => "x\n" }, name: "site-2"))
    refute ok
    assert_includes out, "::error::No Activity data files found in "
  end

  def test_a_base_that_cannot_be_read_fails_clearly
    out, ok = run_check(site(BASE_DATA), "--base", "HEAD^1") # not a git repository
    refute ok
    assert_includes out, "::error::Can't read the base revision HEAD^1, so existing entries can't be checked"

    work = pull_request(depth: 1) { |origin| append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0")) }
    out, ok = run_workflow_check(work)
    refute ok, "a depth-1 checkout has no HEAD^1"
    assert_includes out, "::error::Can't read the base revision HEAD^1"
  end

  def test_arguments_are_checked
    out, ok = run_check(site(BASE_DATA), "--base")
    refute ok
    assert_includes out, "::error::--base needs a git revision"
    out, ok = run_check(site(BASE_DATA, name: "site-2"), "--frob")
    refute ok
    assert_includes out, "::error::Unknown argument --frob"
  end

  # On a pull request (any author), entries already on main must stay as they are.

  def test_a_pull_request_that_appends_an_entry_passes
    work = pull_request { |origin| append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0")) }
    out, ok = run_workflow_check(work)
    assert ok, out
    assert_includes out, "Compared with the base HEAD^1"
    assert_includes out, "the 3 entries in its 2 files are unchanged"
  end

  def test_a_pull_request_that_changes_an_entry_fails
    work = pull_request { |origin| edit(origin, SOFTWARE) { |yaml| yaml.gsub("v0.12.0", "v0.12.1") } }
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{SOFTWARE}, entry 1: changed (version, url) from the base " \
                         "(release QuantEcon.py v0.12.0 2026-09-24). Existing entries can't change: add new entries after them."
  end

  def test_a_pull_request_that_removes_an_entry_fails
    work = pull_request { |origin| edit(origin, LECTURES) { |yaml| yaml.sub(TRANSLATION, "") } }
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{LECTURES}, entry 2: removed. It exists at the base " \
                         "(translation Python Programming for Economics and Finance (French) 2026-09-27)"
  end

  def test_a_pull_request_that_deletes_a_file_fails
    work = pull_request { |origin| File.delete(File.join(origin, SOFTWARE)) }
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{SOFTWARE}: deleted, but it exists at the base (HEAD^1)"
  end

  def test_a_pull_request_that_puts_a_new_entry_first_fails
    work = pull_request do |origin|
      edit(origin, SOFTWARE) { |yaml| yaml.sub("- date", "#{release('2026-09-24', 'QuantEcon.jl', 'v0.17.0')}- date") }
    end
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{SOFTWARE}, entry 1: added before existing entries " \
                         "(release QuantEcon.jl v0.17.0 2026-09-24). Add new entries after the existing ones."
    assert_equal 1, out.scan(/^::error::/).size, out
  end

  def test_a_pull_request_that_removes_an_earlier_entry_names_only_that_entry
    work = pull_request { |origin| edit(origin, LECTURES) { |yaml| yaml.sub(LECTURE_UPDATE, "") } }
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{LECTURES}, entry 1: removed. It exists at the base " \
                         "(lectures Intermediate Quantitative Economics with Python 2026-09-27)"
    assert_equal 1, out.scan(/^::error::/).size, out
  end

  def test_a_pull_request_that_reorders_entries_fails
    work = pull_request { |origin| edit(origin, LECTURES) { HEADER + TRANSLATION + LECTURE_UPDATE } }
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{LECTURES}: the existing entries are in a different order from the base. " \
                         "Keep their order, and add new entries after them."
    assert_equal 1, out.scan(/^::error::/).size, out
  end

  def test_a_file_with_a_non_ascii_name_is_compared_with_the_base
    cafe = "_data/activity/2026-09-29-café.yml"
    work = pull_request(base: BASE_DATA.merge(cafe => release("2026-09-29", "Café.jl", "v1.0.0"))) do |origin|
      edit(origin, cafe) { |yaml| yaml.gsub("v1.0.0", "v1.0.1") }
    end
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{cafe}, entry 1: changed (version, url) from the base (release Café.jl v1.0.0 2026-09-29)."
  end

  def test_a_pull_request_that_only_reformats_passes_the_data_check
    # The data check compares entries, not bytes; the reporter's byte-level limit is the guard's.
    work = pull_request { |origin| edit(origin, SOFTWARE) { |yaml| yaml.delete_prefix(HEADER) } }
    out, ok = run_workflow_check(work)
    assert ok, out
  end
end

class ReporterPullRequestLimitTest < Minitest::Test
  include ActivityTestHelpers

  def test_the_workflow_runs_the_guard_first_and_only_for_the_reporter_app
    assert_equal({ "contents" => "read" }, WORKFLOW["permissions"])
    assert_equal ["build"], WORKFLOW["jobs"].keys, "build is the required status check"
    checkout = STEPS[0]
    assert_match %r{\Aactions/checkout@}, checkout["uses"]
    assert_equal 2, checkout.dig("with", "fetch-depth")
    assert_same guard_step, STEPS[1], "the guard must run right after checkout, before any code the PR controls"
    assert_equal "github.event.pull_request.user.id == #{BOT_USER_ID}", guard_step["if"]
    assert_equal "bash", guard_step["shell"]
    refute_includes guard_step["run"], "${{", "the script must run exactly as written here"
    refute_match(/\b(ruby|bundle|python3?|node|jq)\b/, guard_step["run"])
    setup_ruby = STEPS.index { |step| step["uses"].to_s.start_with?("ruby/setup-ruby@") }
    assert_operator setup_ruby, :>, 1
    check = STEPS.index { |step| step["name"] == "Check Activity data" }
    assert_operator check, :>, setup_ruby
    assert_equal "ruby #{CHECK_SCRIPT} --base HEAD^1", STEPS[check]["run"]
  end

  def test_a_new_day_file_passes
    work = pull_request do |origin|
      write_files(origin, NEW_DAY => HEADER + release("2026-09-30", "QuantEcon.jl", "v0.17.0"))
    end
    assert_equal "true", git("rev-parse", "--is-shallow-repository", chdir: work).strip
    out, ok = run_guard(work)
    assert ok, out
    assert_includes out, "Reporter PR changes only Activity day files: 1 added, 0 appended to."
    out, ok = run_workflow_check(work)
    assert ok, out
  end

  def test_an_append_passes
    work = pull_request do |origin|
      append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0"))
      pull = "https://github.com/QuantEcon/lecture-python.myst/pull/1071"
      append(origin, LECTURES, lectures("2026-09-27", "Fixed a typo.", [["Fix a typo", pull]]))
    end
    out, ok = run_guard(work)
    assert ok, out
    assert_includes out, "0 added, 2 appended to."
    out, ok = run_workflow_check(work)
    assert ok, out
  end

  def test_changes_on_main_after_the_branch_are_not_counted
    work = pull_request(main_later: { "_layouts/activity.html" => "<div>changed on main</div>\n" }) do |origin|
      append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0"))
    end
    out, ok = run_guard(work)
    assert ok, out
  end

  def test_a_rewrite_of_an_existing_file_fails
    work = pull_request { |origin| edit(origin, LECTURES) { |yaml| yaml.sub("two lectures", "three lectures") } }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR rewrites #{LECTURES}: only appends are allowed"
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{LECTURES}, entry 1: changed (summary) from the base"
  end

  def test_a_deletion_fails
    work = pull_request { |origin| File.delete(File.join(origin, SOFTWARE)) }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR deletes #{SOFTWARE}: Activity files are append-only"
  end

  def test_a_rename_fails
    renamed = "_data/activity/2026-09-25-software.yml"
    work = pull_request { |origin| File.rename(File.join(origin, SOFTWARE), File.join(origin, renamed)) }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR deletes #{SOFTWARE}"
    refute_includes out, "::error::Reporter PR adds #{renamed}"
  end

  def test_an_edit_to_a_layout_fails_even_with_an_append
    work = pull_request do |origin|
      append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0"))
      edit(origin, "_layouts/activity.html") { |html| html.sub("activity-feed", "activity-feed evil") }
    end
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR changes _layouts/activity.html: it may only add or append to " \
                         "_data/activity/YYYY-MM-DD-software.yml and -lectures.yml files"
    refute_includes out, "::error::Reporter PR rewrites #{SOFTWARE}"
  end

  def test_an_edit_to_the_gemfile_fails
    work = pull_request { |origin| append(origin, "Gemfile", "gem \"evil\"\n") }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR changes Gemfile:"
  end

  def test_files_that_are_not_day_files_fail
    names = %w[
      _data/activity/notes.yml _data/activity/2026-09-30-software-backfill.yml _data/activity/2026-09-30-news.yml
      _data/activity/2026-09-30-software.yaml _data/activity/2026-9-30-lectures.yml _data/activity/sub/2026-09-30-software.yml
      _data/2026-09-30-software.yml _plugins/activity.rb
      _data/activity/2026-09-30-software.yml.json docs/_data/activity/2026-09-30-software.yml
    ]
    entry = release("2026-09-30", "QuantEcon.jl", "v0.17.0")
    work = pull_request { |origin| write_files(origin, names.to_h { |name| [name, entry] }) }
    out, ok = run_guard(work)
    refute ok
    names.each { |name| assert_includes out, "::error::Reporter PR changes #{name}: it may only add or append" }
  end

  def test_a_mode_change_fails
    work = pull_request { |origin| File.chmod(0o755, File.join(origin, SOFTWARE)) }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR changes #{SOFTWARE} from a regular file to an executable file"
  end

  def test_an_added_symlink_or_executable_fails
    executable = "_data/activity/2026-09-30-lectures.yml"
    work = pull_request do |origin|
      File.symlink(File.basename(SOFTWARE), File.join(origin, NEW_DAY))
      write_files(origin, executable => BOOK)
      File.chmod(0o755, File.join(origin, executable))
    end
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR adds #{NEW_DAY} as a symlink: only regular files are allowed"
    assert_includes out, "::error::Reporter PR adds #{executable} as an executable file"
  end

  def test_an_append_that_changes_the_last_entry_passes_the_guard_but_not_the_data_check
    # With no final newline, appended bytes continue the old last line: here, the summary.
    last = "- date: 2026-09-27\n  type: translation\n  project: Python Programming for Economics and Finance (French)\n" \
           "  url: https://quantecon.github.io/lecture-python-programming.fr/\n  summary: Synced the French edition"
    work = pull_request(base: BASE_DATA.merge(LECTURES => HEADER + last)) do |origin|
      append(origin, LECTURES, " with the English source.\n#{lectures('2026-09-27', 'Fixed a typo.', [['Fix a typo', PULL_1070]])}")
    end
    out, ok = run_guard(work)
    assert ok, out
    assert_includes out, "0 added, 1 appended to."
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{LECTURES}, entry 1: changed (summary) from the base " \
                         "(translation Python Programming for Economics and Finance (French) 2026-09-27)"
  end

  def test_an_append_that_starts_a_second_yaml_document_passes_the_guard_but_not_the_data_check
    # Jekyll reads only a file's first document, so the entries after --- would be neither checked nor shown.
    work = pull_request do |origin|
      append(origin, SOFTWARE, "---\n#{release('2026-09-24', 'QuantEcon.py', 'v0.12.0')}")
    end
    out, ok = run_guard(work)
    assert ok, out
    assert_includes out, "0 added, 1 appended to."
    out, ok = run_workflow_check(work)
    refute ok
    assert_includes out, "::error::#{SOFTWARE}: holds 2 YAML documents, but Jekyll reads only the first."
  end

  def test_head_that_is_not_a_merge_commit_fails
    # The PR's own head commit has a parent, and its change alone would pass: only the merge check fails it.
    work = pull_request(checkout: "refs/heads/pr") do |origin|
      append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0"))
    end
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::HEAD^2, the pull request's head, is missing, so the reporter PR's changes " \
                         "can't be checked. This step needs the PR's merge commit, checked out with fetch-depth: 2"
    refute_includes out, "Reporter PR changes only"
  end

  def test_a_checkout_without_the_merge_commits_parents_fails
    work = pull_request(depth: 1) { |origin| append(origin, SOFTWARE, release("2026-09-24", "QuantEcon.jl", "v0.17.0")) }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::HEAD^2, the pull request's head, is missing"
  end

  def test_paths_cannot_inject_workflow_commands
    work = pull_request { |origin| write_files(origin, "notes\n::warning::injected.txt" => "x\n") }
    out, ok = run_guard(work)
    refute ok
    assert_includes out, "::error::Reporter PR changes notes%0A::warning::injected.txt:"
    refute_match(/^::warning::/, out)
  end
end
