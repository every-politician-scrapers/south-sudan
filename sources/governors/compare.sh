#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb $(jq -r .source meta.json) |
  qsv select id,name,position,positionLabel,state,stateLabel |
  qsv rename item,itemLabel,position,positionLabel,state,stateLabel > scraped.csv

wd sparql -f csv wikidata.js |
  sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' |
  # qsv dedup -s psid |
  qsv select item,name,position,positionLabel,state,stateLabel,source,sourceDate,psid |
  qsv rename item,itemLabel,position,positionLabel,state,stateLabel,source,sourceDate,psid > wikidata.csv

bundle exec ruby diff.rb | tee diff.csv

cd ~-
