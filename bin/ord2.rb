#!/usr/bin/env ruby
# Use folder as track name
# ./bin/ord2.rb ~/books/Agassi_Open -r 
# Use custom as title/track name
# ./bin/ord2.rb ~/books/Agassi_Open -r -t "Agassi Open"
# DRY RUN
# ./bin/ord2.rb ~/books/Agassi_Open -d -r -t "Agassi Open
require 'optparse'
require_relative './../lib/kenglish/mp3_file_reorg'
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

Kenglish::Mp3FileReog.new(src_dir, options).run


