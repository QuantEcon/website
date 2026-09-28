# Check the Activity feed data in _data/activity/*.yml against the schema in
# README.md ("News and Activity"). The reporter bot writes these files, so a bad
# file should fail its PR with a message that names the file, rather than break
# the Jekyll build or render silently.
require "date"
require "yaml"

DATA_DIR = File.expand_path("../../_data/activity", __dir__)
TYPES = %w[release lectures translation].freeze
REQUIRED = %w[date type project url].freeze
PULL_URL = %r{\Ahttps://github\.com/[^/]+/[^/]+/pull/\d+\z}

def blank?(value)
  value.nil? || value.to_s.strip.empty?
end

paths = Dir.glob(File.join(DATA_DIR, "*.{yml,yaml}")).sort
if paths.empty?
  puts "::error::No Activity data files found in #{DATA_DIR}"
  exit 1
end

errors = []
paths.each do |full_path|
  path = full_path.delete_prefix("#{File.expand_path('../..', __dir__)}/")
  begin
    entries = YAML.safe_load(File.read(full_path), permitted_classes: [Date])
  rescue Psych::Exception => e
    errors << "#{path}: invalid YAML (#{e.message})"
    next
  end
  unless entries.is_a?(Array) && !entries.empty?
    errors << "#{path}: must be a non-empty list of entries"
    next
  end

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

if errors.empty?
  puts "Activity data OK (#{paths.size} files)"
else
  errors.each { |error| puts "::error::#{error}" }
  exit 1
end
