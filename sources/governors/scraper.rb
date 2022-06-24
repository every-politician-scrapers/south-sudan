#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath('//table[.//tr[contains(., "Governor")]][2]//tr[td]')
    end
  end

  class Member
    field :id do
      tds[3].css('a/@wikidata').text
    end

    field :name do
      tds[3].css('a').text
    end

    field :state do
      tds[1].css('a/@wikidata').text
    end

    field :stateLabel do
      tds[1].css('a').text
    end

    field :position do
    end

    field :positionLabel do
      "Governor of #{stateLabel}"
    end

    private

    def tds
      noko.css('td')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
