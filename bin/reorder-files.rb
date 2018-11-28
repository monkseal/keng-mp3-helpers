require 'fileutils'
require 'taglib'

files = Dir['split/*']
new_dir = 'renamed'
Dir.mkdir(new_dir) unless Dir.exist?(new_dir)

files.sort.each_with_index do |f, i|
  track = i + 1
  new_title = "#{sprintf('%03d', track)} - Right Stuff"
  new_file_path = "#{new_dir}/#{new_title}.mp3"

  puts f
  puts new_file_path
  FileUtils.cp(f, new_file_path)
  TagLib::MPEG::File.open(new_file_path) do |file|
    tag2 = file.id3v2_tag
    tag1 = file.id3v1_tag

    puts tag1.title
    puts tag2.track
    puts tag1.title
    puts tag2.track
    tag1.title = new_title
    tag1.track = track
    tag2.title = new_title
    tag2.track = track
    file.save
  end
end

# Load a tag from a file
# tag = ID3Lib::Tag.new('talk.mp3')
# files = Dir['renamed/*']
#
# file_groups = files.sort.each_slice(11).to_a
# file_groups.each_with_index do |file_group, i|
#    new_dir = "Part#{sprintf '%02d', (i + 1)}"
#    Dir.mkdir(new_dir) unless Dir.exist?(new_dir)
#    file_group.each do|f|
#      FileUtils.cp(f, new_dir)
#    end
#   puts new_dir
# end
