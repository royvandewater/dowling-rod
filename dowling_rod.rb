#!/usr/bin/env ruby
require 'rest_client'
require 'nokogiri'
require 'ruby-debug'

class DowlingRod
  API_URL = "http://www.google.com/ig/api?weather="

  attr_accessor :zipcode, :conditions

  def initialize(hash={})
    @zipcode = hash[:zipcode]
  end

  def conditions
    return @conditions unless @conditions.nil?
    xml = Nokogiri::XML(RestClient.get API_URL + @zipcode.to_s)
    @conditions = xml.xpath('//condition').collect {|condition| condition.attr 'data'}
  end

  def write_conditions_to_file(filename)
    File.open(filename, 'a+') do |file|
      file.write conditions.join "\n"
    end
  end
end

if __FILE__ == $0
  dowling_rod = DowlingRod.new :zipcode => 85225
  dowling_rod.write_conditions_to_file 'weather.txt'
end
