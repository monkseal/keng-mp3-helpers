# frozen_string_literal: true

require "fileutils"
require "pry"
require 'ffprober'

module Kenglish
  class Mp3Split
    attr_reader :src_file_or_dir, :options, :split_minutes

    DEFAULT_SPLIT_MINUTES = "20.00"

    def initialize(src_file_or_dir, options)
      @src_file_or_dir = src_file_or_dir
      @options = options
      if options[:split_minutes].nil? && File.file?(src_file_or_dir)
        @split_minutes = calculate_split_minutes(src_file_or_dir)
      else
        @split_minutes = format("%.2f", options.fetch(:split_minutes, DEFAULT_SPLIT_MINUTES).to_f)
      end
    end

    def run
      if File.file?(src_file_or_dir)
        split_file(src_file_or_dir)
      elsif Dir.exist?(src_file_or_dir)
        split_into_new_dir(src_file_or_dir)
      else
        raise "src_file_or_dir is not a file or director (#{src_file_or_dir})"
      end
    end

    def split_into_new_dir(src_dir)
      root_dir = File.dirname(src_dir)
      basename_dir = File.basename(src_dir)
      split_basename_dir = "#{basename_dir}-split"
      split_dir = File.join(root_dir, split_basename_dir)
      raise "#{split_dir} already exists" if Dir.exist?(split_dir)

      puts "Splitting #{split_dir}"
      cmd = "mp3splt -t #{split_minutes} -d #{split_dir.shellescape}  #{src_dir.shellescape}/*.mp3"
      result = `#{cmd}`

      split_dir
    end

    def split_file(src_file)
      raise "src_file is not an mp3" unless src_file.downcase.end_with?(".mp3")

      root_dir = File.dirname(src_file)
      filename = File.basename(src_file)
      split_basename_dir = "#{filename[0...-4]}-split"
      split_dir = File.join(root_dir, split_basename_dir)
      raise "#{split_dir} already exists" if Dir.exist?(split_dir)

      puts "Splitting file src_file #{src_file} into split_dir #{split_dir}"
      cmd = "mp3splt -t #{split_minutes} -d #{split_dir.shellescape}  #{src_file.shellescape}"
      result = `#{cmd}`
      split_dir
    end

    def calculate_split_minutes(src_file_or_dir)
      
      ffprobe = Ffprober::Parser.from_file(src_file_or_dir)
      duration = ffprobe.format.duration.to_f / 60.0
      split_size = 100.0
      split_size = 50.0 if duration < 1000.0
      split_size = 30.0 if duration < 500.0
      split_minutes = (duration / split_size ).ceil(2)
      minutes = split_minutes.floor
      fraction = split_minutes - minutes
      seconds = (fraction * 60).round(0)
      "#{minutes}.#{seconds}"
    end
  end
end
