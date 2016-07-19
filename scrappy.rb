require 'ostruct'
require 'mechanize'
require 'logger'
require_relative 'lib/page_parser'
require_relative 'lib/scraper'

module Scrappy
  def self.start isbns, &block
    Scraper.new.start(isbns, &block)
  end
end
