# frozen_string_literal: true

require 'forwardable'
require_relative 'timetable'
require 'csv'


#Class of TimeTable list
class TimeTableList
  include Enumerable

  def initialize(file_name)
    @timetable_list = read_data(file_name)
  end

  def read_data(file_name)
    list = []
    CSV.foreach(file_name, headers: true) do |row|
      timetable_item = TimeTable.new(
        day: row['DAY'],
        number_pair: row['NUMBER_PAIR'],
        subject: row['SUBJECT'],
        teacher: row['TEACHER'],
        audience: row['AUDIENCE'],
        group: row['GROUP']
      )
      list.append(timetable_item)
    end
    list
  end

  def add_item(item)
    @timetable_list.append(item)
  end

  def all_items
    @timetable_list.dup
  end

  def sorted_by_number_of_audience
    @timetable_list.sort do |a, b|
      a.audience_number.to_i <=> b.audience_number.to_i
    end
  end

  def filter(forma)
    list = @book_list.select do |book|
      next if forma && !book.r_format.eql?(forma)

      true
    end
    list.sort { |a, b| b <=> a }
  end

  def each
    @timetable_list.each do |element|
      yield element
    end
  end
end
