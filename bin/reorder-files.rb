# frozen_string_literal: true

# ruby bin/reorder-files.rb "~/Music/Audio Books/Men Who Lost America/100" "Men Who Lost America 100"

require "fileutils"
require "taglib"

if ARGV.length < 2
  raise "Too few arguments"
  exit
end

src_dir = ARGV[0]
track_postfix = ARGV[1]
dry_run = ARGV[2]
raise "Dir.exist?(#{src_dir}) fail" unless Dir.exist?(src_dir)
files = Dir["#{ARGV.first}/*"]
new_dir = "#{ARGV.first}-renamed"
Dir.mkdir(new_dir) unless Dir.exist?(new_dir)

files.sort.each_with_index do |f, i|
  track = i + 1
  new_title = "#{format('%03d', track)} - #{track_postfix}"
  new_file_path = "#{new_dir}/#{new_title}.mp3"

  puts f
  puts new_file_path
  if dry_run
    puts "--- DRY RUN -- nothing copied"
  else
    FileUtils.cp(f, new_file_path)
    TagLib::MPEG::File.open(new_file_path) do |file|
      tag2 = file.id3v2_tag
      tag1 = file.id3v1_tag
      tag1.title = new_title
      tag1.track = track
      tag1.album = track_postfix
      tag2.title = new_title
      tag2.track = track
      tag2.album = track_postfix
      file.save
    end
  end
end
