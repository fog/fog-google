require "fileutils"

# Helper method to insert text after a line that matches the regex
def insert_after_line(file, insert, regex = /^## Next/)
  tempfile = File.open("#{file}.tmp", "w")
  f = File.new(file)
  f.each do |line|
    tempfile << line
    next unless line =~ regex

    tempfile << "\n"
    tempfile << insert
    tempfile << "\n"
  end
  f.close
  tempfile.close

  FileUtils.mv("#{file}.tmp", file)
end

# Extracts all changes that have been made after the latest pushed tag
def changes_since_last_tag
  `git --no-pager log $(git describe --tags --abbrev=0)..HEAD --oneline`
end

namespace :changelog do
  task :generate do
    insert_after_line("CHANGELOG.md", changes_since_last_tag, /^## Next/)
  end
end
