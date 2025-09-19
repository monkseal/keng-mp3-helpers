#!/usr/bin/env ruby

# Use folder as track name
# ./bin/reorder-files.rb ~/books/Agassi_Open -r
# Use custom as title/track name
# ./bin/reorder-files.rb ~/books/Agassi_Open -r -t "Agassi Open"
# DRY RUN
# ./bin/reorder-files.rb ~/books/Agassi_Open -d -r -t "Agassi Open
require 'shellwords'
require 'optparse'
require 'fileutils'
require_relative './../lib/kenglish/mp3_file_reorg'
require_relative './../lib/kenglish/mp3_split'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-r", "--recursive", "recursive") do |r|
    options[:recursive] = r
  end
  opts.on("-d", "--dry-run", "dry_run") do |d|
    options[:dry_run] = d
  end
  opts.on("-s", "--split", "split files first") do |s|
    options[:split] = s
  end
  opts.on("-mMINUTES", "--minutes=MINUTES", "split files first") do |split_minutes|
    options[:split_minutes] = split_minutes
  end

  opts.on("-tNAME", "--title=NAME", "title") do |title|
    options[:title] = title
  end
end.parse!

p options
p ARGV

if ARGV.length < 1
  raise "Too few arguments"
  exit
end

src_dir = ARGV[0]

if options[:split]
  split_dir = Kenglish::Mp3Split.new(src_dir, options).run
  Kenglish::Mp3FileReog.new(split_dir, options).run
  FileUtils.rm_rf(split_dir)
else
  Kenglish::Mp3FileReog.new(src_dir, options).run
end


