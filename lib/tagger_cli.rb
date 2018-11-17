# frozen_string_literal: true

require "thor"
require "taglib"
require "pathname"
class MissingYear
  attr_reader :dir, :cli
  # delegate :say, :ask, to: :cli
  # delegate :say, to: :cli
  def initialize(cli, dir)
    @cli = cli
    @dir = dir
  end

  def start
    cli.say "Hello #{dir}"

    files = Dir[filter_dir]
    files.each do |f|
      tag_mp3_year(f)
    end
  end

  def tag_mp3_year(f)
    TagLib::MPEG::File.open(f) do |mp3|
      tag1 = mp3.id3v1_tag
      tag2 = mp3.id3v2_tag
      if tag1.year.zero? && tag2.year.zero?
        cli.say f
        cli.say "ARTIST: #{tag1.artist} | #{tag2.artist} TITLE: #{tag1.title} | #{tag2.title},"
        year = cli.ask("Replace with year?")
        cli.say("year = --#{year}--#{year.class}")
        if year.to_i > 1900 && year.to_i < 2100
          tag1.year = tag2.year = year.to_i
          mp3.save
        else
          cli.say "Year #{year} is invalid"
        end
      else
        sync_tag_years(mp3, tag1, tag2)
      end
    end
  end

  def sync_tag_years(mp3, tag1, tag2)
    return if tag1.year == tag2.year
    if tag1.year == 0
      tag1.year = tag2.year
    else
      tag2.year = tag1.year
    end
    mp3.save
  end

  def filter_dir
    "#{dir}/**/*.mp3"
  end
end

class TaggerCLI < Thor
  desc "find_missing_years directoy", "find all mp3 files that do not have a 'year' field"
  def find_missing_years(dir)
    MissingYear.new(self, dir).start
  end
end
