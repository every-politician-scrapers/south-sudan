#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  # decorator WikidataIdsDecorator::Links

  def header_column
    'Party'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name dates].freeze
    end

    def raw_combo_date
      super.gsub('Since', '').gsub(' to ', '–')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
