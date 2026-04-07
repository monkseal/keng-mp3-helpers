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
require_relative './../lib/kenglish/m4b_converter'
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

if File.file?(src_dir) && File.extname(src_dir) == '.m4b'
  output_file = Kenglish::M4bConverter.new(src_dir).run
  split_dir = Kenglish::Mp3Split.new(output_file, options).run
  Kenglish::Mp3FileReog.new(split_dir, options).run
  FileUtils.rm_rf(split_dir)
else
  if Dir.exist?(src_dir)
    m4b_files = Dir.entries(src_dir).select { |f| File.extname(f) == '.m4b' }.sort.map { |f| File.join(src_dir, f) }
    m4b_files.each { |f| Kenglish::M4bConverter.new(f).run } if m4b_files.any?
  end

  if options[:split]
    split_dir = Kenglish::Mp3Split.new(src_dir, options).run
    Kenglish::Mp3FileReog.new(split_dir, options).run
    FileUtils.rm_rf(split_dir)
  else
    Kenglish::Mp3FileReog.new(src_dir, options).run
  end
end


