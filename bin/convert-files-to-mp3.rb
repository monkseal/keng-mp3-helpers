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
# require_relative './../lib/kenglish/mp3_file_reorg'
# require_relative './../lib/kenglish/mp3_split'
# options = {}
# OptionParser.new do |opts|
#   opts.banner = "Usage: example.rb [options]"

#   opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
#     options[:verbose] = v
#   end
#   opts.on("-r", "--recursive", "recursive") do |r|
#     options[:recursive] = r
#   end
#   opts.on("-d", "--dry-run", "dry_run") do |d|
#     options[:dry_run] = d
#   end
#   opts.on("-s", "--split", "split files first") do |s|
#     options[:split] = s
#   end
#   opts.on("-mMINUTES", "--minutes=MINUTES", "split files first") do |split_minutes|
#     options[:split_minutes] = split_minutes
#   end

#   opts.on("-tNAME", "--title=NAME", "title") do |title|
#     options[:title] = title
#   end
# end.parse!

# p options
# p ARGV

# if ARGV.length < 1
#   raise "Too few arguments"
#   exit
# end

src_dir = ARGV[0]

if src_dir.nil? || src_dir.empty?
  puts "Usage: #{$0} <directory>"
  exit 1
end

unless Dir.exist?(src_dir)
  puts "Error: Directory '#{src_dir}' does not exist"
  exit 1
end

puts "Processing files in #{src_dir}:"
Dir.glob(File.join(src_dir, '*')).sort.each do |file|
  next unless File.file?(file)

  if File.extname(file) == '.m4b'
    basename = File.basename(file, '.m4b')
    input_file = file
    output_file = File.join(File.dirname(file), "#{basename}.mp3")

    puts "Converting: #{File.basename(file)} -> #{basename}.mp3"
    cmd = "ffmpeg -i #{Shellwords.escape(input_file)} #{Shellwords.escape(output_file)}"
    system(cmd)

    if $?.success?
      puts "  ✓ Successfully converted #{basename}.mp3"
    else
      puts "  ✗ Failed to convert #{File.basename(file)}"
    end
  else
    puts "Skipping: #{File.basename(file)} (not .m4b)"
  end
end

# if options[:split]
#   split_dir = Kenglish::Mp3Split.new(src_dir, options).run
#   Kenglish::Mp3FileReog.new(split_dir, options).run
#   FileUtils.rm_rf(split_dir)
# else
#   Kenglish::Mp3FileReog.new(src_dir, options).run
# end


