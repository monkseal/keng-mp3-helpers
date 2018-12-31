# frozen_string_literal: true

require "fileutils"
require "taglib"

if ARGV.length < 1
  raise "Too few arguments"
  exit
end
NO_ARTIST = 'NoArtist'
src_dir = ARGV[0]
dry_run = ARGV[1]
raise "Dir.exist?(#{src_dir}) fail" unless Dir.exist?(src_dir)
files = Dir["#{ARGV.first}/**/*.mp3"]

def artist_from(list)
  head = list.first
  return head if list.size == 1
  if head.nil? || head == ''
    artist_from(list[1..-1])
  else
    head
  end
end

def collect_artist(files)
  files.each_with_object({}) do |f, artists|
    # puts f
    artist = nil
    TagLib::MPEG::File.open(f) do |file|
      tag2 = file.id3v2_tag
      tag1 = file.id3v1_tag
      artist = artist_from([tag1.artist, tag2.artist, NO_ARTIST])
    end
    artists[artist] ||= []
    artists[artist] << f
    # puts "#{artist} #{artists[artist].size}"
  end
end

def reorg_mp3s(src_dir, artists)
  artists.each do |artist, files|
    if files.size < 3
      puts "SKIP artist =>#{artist} #{files.size}"
      next
    end
    new_dir = [src_dir, artist].join("/")
    Dir.mkdir(new_dir) unless Dir.exist?(new_dir)

    puts "new_dir => #{new_dir}"
    files.each do|old_path|
      mp3 = File.basename(old_path)
      new_path = [new_dir,mp3].join("/")
      next if old_path == new_path
      FileUtils.mv old_path, new_path
    end
  end
end
artists = collect_artist(files)

puts "NoArtist #{artists["NoArtist"]}"
reorg_mp3s(src_dir, artists)

