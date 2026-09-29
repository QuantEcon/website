# Check the Activity feed data in _data/activity/*.yml against the schema in
# README.md ("News and Activity"). The reporter bot writes these files, so a bad
# file should fail its PR with a message that names the file, rather than break
# the Jekyll build or render silently.
#
# Jekyll shows everything it reads from _data/activity/, so the directory may hold
# only YAML files, each a single YAML document. Beyond each entry's fields, a
# release or a pull request may be listed only once across all the files. With
# --base <revision>, the files must also be append-only relative to that revision:
# every data file there must still exist and start with the same entries,
# unchanged. CI passes the pull request's base (HEAD^1 of its merge commit).
# Without --base, as in a local run, only that comparison is skipped.
#
#   ruby .github/scripts/check-activity-data.rb [--base <revision>]
require "date"
require "open3"
require "yaml"

ROOT = File.expand_path("../..", __dir__)
DATA_DIR = File.join(ROOT, "_data/activity")
# Like Jekyll, skip names that start with a dot.
DATA_FILE = %r{\A_data/activity/[^./][^/]*\.ya?ml\z}
TYPES = %w[release lectures translation book].freeze
REQUIRED = %w[date type project url].freeze
PULL_URL = %r{\Ahttps://github\.com/[^/]+/[^/]+/pull/\d+\z}
USAGE = "Usage: ruby .github/scripts/check-activity-data.rb [--base <revision>]".freeze

# Raised when the base revision's files can't be read.
class BaseError < StandardError; end

def blank?(value)
  value.nil? || value.to_s.strip.empty?
end

def load_entries(yaml)
  YAML.safe_load(yaml, permitted_classes: [Date])
end

# GitHub owner and repository names are case-insensitive, so two URLs that differ
# only there name the same release or pull request.
def url_key(url)
  url.sub(%r{\Ahttps://github\.com/[^/]+/[^/]+}i, &:downcase)
end

# A workflow command ends at a newline, and file names and YAML values can hold
# one, so escape it (with % and CR) the way GitHub's toolkit does.
def annotation(message)
  message.gsub("%", "%25").gsub("\r", "%0D").gsub("\n", "%0A")
end

def describe(entry)
  return "not a mapping" unless entry.is_a?(Hash)

  entry.values_at("type", "project", "version", "date").compact.join(" ")
end

# How a file's entries differ from its entries at the base, as error messages.
# Entries are matched by value, so that one removed or inserted entry doesn't make
# every later entry look changed.
def entry_differences(path, old_entries, new_entries)
  return [] if new_entries.first(old_entries.size) == old_entries

  errors = []
  unmatched = (0...new_entries.size).to_a # current entries equal to no base entry
  found = {} # base index => current index of an equal entry
  old_entries.each_with_index do |old_entry, i|
    j = unmatched.find { |k| new_entries[k] == old_entry }
    found[i] = unmatched.delete(j) if j
  end
  old_entries.each_with_index do |old_entry, i|
    next if found.key?(i)

    where = "#{path}, entry #{i + 1}"
    if unmatched.delete(i) # the entry in its place now is new: an edit
      new_entry = new_entries[i]
      keys = []
      if old_entry.is_a?(Hash) && new_entry.is_a?(Hash)
        keys = (old_entry.keys | new_entry.keys).reject { |key| old_entry[key] == new_entry[key] }
      end
      what = keys.empty? ? "changed" : "changed (#{keys.join(', ')})"
      errors << "#{where}: #{what} from the base (#{describe(old_entry)}). " \
                "Existing entries can't change: add new entries after them."
    else
      errors << "#{where}: removed. It exists at the base (#{describe(old_entry)}), and existing entries must stay."
    end
  end
  last = found.values.max
  return errors unless last

  unmatched.select { |j| j < last }.each do |j|
    errors << "#{path}, entry #{j + 1}: added before existing entries (#{describe(new_entries[j])}). " \
              "Add new entries after the existing ones."
  end
  order = found.sort.map(&:last)
  unless order == order.sort
    errors << "#{path}: the existing entries are in a different order from the base. " \
              "Keep their order, and add new entries after them."
  end
  errors
end

def git(*args, stdin: "")
  out, err, status = Open3.capture3("git", "-C", ROOT, *args, stdin_data: stdin, binmode: true)
  return out if status.success?

  raise BaseError, "git #{args.first} failed (#{err.strip.empty? ? "exit #{status.exitstatus}" : err.strip})"
rescue SystemCallError => e
  raise BaseError, "can't run git (#{e.message})"
end

# The data files at a revision, as [commit, { path => file content }].
def base_files(revision)
  commit = git("rev-parse", "--verify", "#{revision}^{commit}").strip
  blobs = git("ls-tree", "-z", commit, "--", "_data/activity/").split("\0").filter_map do |record|
    info, path = record.split("\t", 2)
    _mode, type, oid = info.split(" ")
    # git's output is bytes: tag the path as UTF-8, like the names read from disk.
    [path.force_encoding(Encoding::UTF_8), oid] if type == "blob" && path.match?(DATA_FILE)
  end
  return [commit, {}] if blobs.empty?

  # One `git cat-file --batch` call reads every blob: "<oid> blob <size>\n<content>\n".
  out = git("cat-file", "--batch", stdin: blobs.map { |_, oid| "#{oid}\n" }.join)
  offset = 0
  files = blobs.to_h do |path, oid|
    header_end = out.index("\n", offset) or raise BaseError, "git cat-file returned no header for #{path}"
    _oid, type, size = out.byteslice(offset...header_end).split(" ")
    raise BaseError, "git cat-file can't read #{path} (#{oid}): #{type}" unless type == "blob"

    content = out.byteslice(header_end + 1, size.to_i).force_encoding(Encoding::UTF_8)
    offset = header_end + 1 + size.to_i + 1
    [path, content]
  end
  [commit, files]
end

base = nil
args = ARGV.dup
until args.empty?
  arg = args.shift
  if arg == "--base"
    base = args.shift.to_s
  elsif arg.start_with?("--base=")
    base = arg.delete_prefix("--base=")
  else
    puts "::error::#{annotation("Unknown argument #{arg}. #{USAGE}")}"
    exit 1
  end
  next unless blank?(base) || base.start_with?("-")

  puts "::error::--base needs a git revision, such as HEAD^1. #{USAGE}"
  exit 1
end

errors = []
notes = []

# Jekyll reads every .yml, .yaml, .json, .csv and .tsv file in _data/activity/,
# and every subdirectory, and the Activity page shows it all. This check reads
# only the YAML files, so anything else fails.
paths = []
names = Dir.exist?(DATA_DIR) ? Dir.children(DATA_DIR).sort : []
names.each do |name|
  path = "_data/activity/#{name}"
  full_path = File.join(DATA_DIR, name)
  if path.match?(DATA_FILE) && File.file?(full_path)
    paths << path
  elsif !name.start_with?(".")
    kind = if File.directory?(full_path) then "a directory"
           elsif path.match?(DATA_FILE) then "not a regular file"
           else "not a .yml or .yaml file"
           end
    errors << "#{path}: #{kind}. _data/activity/ may hold only .yml and .yaml files, the only ones this check " \
              "reads (Jekyll would also show entries from .json, .csv and .tsv files, and from subdirectories)."
  end
end
errors << "No Activity data files found in #{DATA_DIR}" if paths.empty?

parsed = {} # repository path => its entries, or nil when the file is reported as unreadable
paths.each do |path|
  parsed[path] = nil
  begin
    text = File.read(File.join(ROOT, path))
    documents = Psych.parse_stream(text).children.size
    entries = load_entries(text)
  rescue Psych::Exception => e
    errors << "#{path}: invalid YAML (#{e.message})"
    next
  end
  # Jekyll reads only the first document: entries after a `---` line would be neither checked nor shown.
  if documents > 1
    errors << "#{path}: holds #{documents} YAML documents, but Jekyll reads only the first. " \
              "Keep every entry in one list, with no `---` line after the first entry."
    next
  end
  unless entries.is_a?(Array) && !entries.empty?
    errors << "#{path}: must be a non-empty list of entries"
    next
  end
  parsed[path] = entries

  entries.each_with_index do |entry, i|
    where = "#{path}, entry #{i + 1}"
    unless entry.is_a?(Hash)
      errors << "#{where}: must be a mapping"
      next
    end
    missing = REQUIRED.select { |key| blank?(entry[key]) }
    errors << "#{where}: missing #{missing.join(', ')}" unless missing.empty?
    errors << "#{where}: date must be an unquoted YYYY-MM-DD date" if entry["date"] && !entry["date"].is_a?(Date)
    errors << "#{where}: type must be one of #{TYPES.join(', ')}" if entry["type"] && !TYPES.include?(entry["type"])
    errors << "#{where}: url must start with https://" unless blank?(entry["url"]) || entry["url"].to_s.start_with?("https://")
    if entry["type"] == "translation" && !entry["project"].to_s.match?(/\A.+ \([^)]+\)\z/)
      errors << "#{where}: a translation's project must be \"<series name> (<language>)\""
    end
    if entry["type"] == "release" && !(entry["version"].is_a?(String) && !blank?(entry["version"]))
      errors << "#{where}: release entries need a version, written as a string (quote numeric-looking versions)"
    end
    if entry.key?("summary")
      summary = entry["summary"]
      if !summary.is_a?(String) || blank?(summary)
        errors << "#{where}: summary must be a non-empty string (omit the key instead)"
      elsif summary.count("`").odd? || summary.include?("``")
        errors << "#{where}: summary has an unmatched or doubled backtick"
      end
    end

    changes = entry["changes"] || []
    unless changes.is_a?(Array)
      errors << "#{where}: changes must be a list"
      next
    end
    errors << "#{where}: changes must not be an empty list (omit the key instead)" if entry.key?("changes") && changes.empty?
    changes.each_with_index do |change, j|
      next if change.is_a?(Hash) && change["title"].is_a?(String) && !blank?(change["title"]) &&
              change["url"].to_s.match?(PULL_URL)
      errors << "#{where}, change #{j + 1}: needs a string title and a GitHub pull-request url"
    end
  end
end

# Each release and each pull request is reported once: the reporter skips any it
# finds in the data, so a second listing means a re-run or an edit duplicated it.
listings = Hash.new { |hash, key| hash[key] = [] }
parsed.each do |path, entries|
  next unless entries

  entries.each_with_index do |entry, i|
    next unless entry.is_a?(Hash)

    where = "#{path}, entry #{i + 1}"
    if entry["type"] == "release" && entry["url"].is_a?(String) && !blank?(entry["url"])
      listings[["Release", url_key(entry["url"])]] << [where, entry["url"]]
    end
    next unless entry["changes"].is_a?(Array)

    entry["changes"].each_with_index do |change, j|
      next unless change.is_a?(Hash) && change["url"].is_a?(String) && !blank?(change["url"])

      listings[["Pull request", url_key(change["url"])]] << ["#{where}, change #{j + 1}", change["url"]]
    end
  end
end
listings.each do |(kind, _key), places|
  next if places.size < 2

  urls = places.map(&:last).uniq
  also = urls.size > 1 ? " (also written #{urls.drop(1).join(', ')})" : ""
  errors << "#{kind} #{urls.first}#{also} is listed #{places.size} times: #{places.map(&:first).join('; ')}. List it once."
end

# Append-only: every entry at the base stays, unchanged and in order, at the start
# of its file, so a re-run can only add entries after the existing ones.
if base
  begin
    commit, files = base_files(base)
    compared_before = errors.size
    compared_files = compared_entries = 0
    files.each do |path, content|
      begin
        old_entries = load_entries(content)
      rescue Psych::Exception
        old_entries = nil
      end
      unless old_entries.is_a?(Array) && !old_entries.empty?
        notes << "Not compared with the base: #{path} isn't a list of entries at #{base}."
        next
      end
      # A base file is compared with the data file of the same name read above. Any
      # other base file counts as deleted, so that nothing is skipped silently.
      unless parsed.key?(path)
        errors << "#{path}: deleted, but it exists at the base (#{base}). Activity files are append-only, so keep it."
        next
      end
      new_entries = parsed[path]
      next unless new_entries # already reported: the file can't be read as one list of entries now

      compared_files += 1
      compared_entries += old_entries.size
      errors.concat(entry_differences(path, old_entries, new_entries))
    end
    if errors.size == compared_before
      notes << "Compared with the base #{base} (#{commit[0, 12]}): " \
               "the #{compared_entries} entries in its #{compared_files} files are unchanged."
    end
  rescue BaseError => e
    errors << "Can't read the base revision #{base}, so existing entries can't be checked: #{e.message}. " \
              "CI's checkout needs fetch-depth: 2; locally, run without --base."
  end
else
  notes << "No --base given, so the check that existing entries are unchanged was skipped (CI passes the pull request's base)."
end

notes.each { |note| puts note }
if errors.empty?
  puts "Activity data OK (#{paths.size} files)"
else
  errors.each { |error| puts "::error::#{annotation(error)}" }
  exit 1
end
