# frozen_string_literal: true

require "fileutils"
require "pry"
module Kenglish
  class Mp3Split
    attr_reader :src_file_or_dir, :options, :split_minutes

    DEFAULT_SPLIT_MINUTES = "18.00"

    def initialize(src_file_or_dir, options)
      @src_file_or_dir = src_file_or_dir
      @options = options
      @split_minutes = options.fetch(:split_minutes, DEFAULT_SPLIT_MINUTES)
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
  end
end
