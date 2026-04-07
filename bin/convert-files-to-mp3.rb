#!/usr/bin/env ruby

require 'shellwords'
require 'optparse'
require 'fileutils'
require_relative './../lib/kenglish/m4b_converter'

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
    Kenglish::M4bConverter.new(file).run
  else
    puts "Skipping: #{File.basename(file)} (not .m4b)"
  end
end
