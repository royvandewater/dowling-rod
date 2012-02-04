#!/usr/bin/env ruby
require 'rest_client'
require 'nokogiri'
require './file_sorter.rb'

class DowlingRod
  API_URL = "http://www.google.com/ig/api?weather="
  FILENAME = 'weather.txt'
  SEATTLE = 98115

  attr_accessor :zipcode, :filename, :conditions

  def initialize(kwargs={})
    @zipcode = kwargs[:zipcode]
    @filename = kwargs[:filename]
  end

  def conditions
    return @conditions unless @conditions.nil?
    xml = Nokogiri::XML(RestClient.get API_URL + @zipcode.to_s)
    @conditions = xml.xpath('//current_conditions/condition').collect {|condition| condition.attr 'data'}
  end

  def save
    File.open(filename, 'a+') do |file|
      file.write "#{conditions.join "\n"}\n"
    end
  end
end

if __FILE__ == $0
  dowling_rod = DowlingRod.new :zipcode => DowlingRod::SEATTLE, :filename => DowlingRod::FILENAME
  dowling_rod.save

  file_sorter = FileSorter.new :filename => DowlingRod::FILENAME
  file_sorter.save
end
