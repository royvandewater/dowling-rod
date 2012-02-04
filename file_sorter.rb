#!/usr/bin/env ruby

class FileSorter
  attr_accessor :filename

  def initialize(kwargs={})
    @filename = kwargs[:filename]
  end

  def contents
    File.open(@filename, 'r') do |file|
      return file.read().split("\n")
    end
  end

  def save
    sorted_contents = contents.sort.uniq
    File.open(@filename, 'w') { |file| file.write "#{sorted_contents.join "\n"}\n" }
  end
end

if __FILE__ == $0
  file_sorter = FileSorter.new :filename => 'sample.txt'
  file_sorter.save
end
