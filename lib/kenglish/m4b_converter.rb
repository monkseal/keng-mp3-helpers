# frozen_string_literal: true

require "shellwords"

module Kenglish
  class M4bConverter
    attr_reader :input_file, :output_file

    def initialize(input_file)
      @input_file = input_file
      basename = File.basename(input_file, '.m4b').gsub(/[.,;:!?'"]/, '')
      @output_file = File.join(File.dirname(input_file), "#{basename}.mp3")
    end

    def run
      if File.exist?(output_file) && File.size(output_file) > 0
        puts "Skipping: #{File.basename(output_file)} already exists"
        return output_file
      end

      puts "Converting: #{File.basename(input_file)} -> #{File.basename(output_file)}"
      cmd = "ffmpeg -i #{Shellwords.escape(input_file)} #{Shellwords.escape(output_file)}"
      system(cmd)

      unless $?.success?
        raise "Failed to convert #{File.basename(input_file)}"
      end

      puts "Successfully converted #{File.basename(output_file)}"
      output_file
    end
  end
end
