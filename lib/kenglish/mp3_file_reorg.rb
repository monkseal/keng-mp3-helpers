require "fileutils"
require "taglib"

module Kenglish
  class Mp3FileReog
    attr_reader :src_dir, :options

    def initialize(src_dir, options)
      @src_dir = src_dir
      @options = options
    end

    def run
      raise "Dir.exist?(#{src_dir}) fail" unless Dir.exist?(src_dir)
      
      Dir.mkdir(new_dir) unless Dir.exist?(new_dir)
      puts "#{new_dir}"

      files = Dir[file_pattern]
      files = files.sort.select{|f| !File.directory?(f) && f =~ /mp3$/ }
      files.sort.each_with_index do |f, i|
        track = i + 1
        rename(f, track)
      end
    end

    def rename(f, track)
      new_title = "#{format('%03d', track)} - #{track_postfix}"
      new_file_path = "#{new_dir}/#{new_title}.mp3"
      if dry_run?
         puts "[DRY RUN] #{f} --> #{new_file_path}"
         return
      end
      puts new_file_path
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


    private

    def dry_run?
      options[:dry_run]
    end

    def track_postfix
      @track_postfix ||= options.fetch(:title, src_dir_base_name)
    end

    def src_dir_base_name
      File.basename(src_dir)
    end

    def file_pattern
      options[:recursive] ? "#{src_dir}/**/*": "#{src_dir}/*"
    end

    def new_dir
      @new_dir ||= "#{src_dir.chomp('/')}-renamed"
    end
  end
end
