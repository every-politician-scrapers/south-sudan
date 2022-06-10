#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  def table_number
    'position()>0'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name img start end].freeze
    end

    def name_cell
      tds[-7]
    end

    def start_cell
      tds[-5]
    end

    def end_cell
      tds[-4]
    end

    def empty?
      itemLabel.include?('Vacant') || super
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
