# frozen_string_literal: true

require 'forwardable'
require_relative 'timetable'
require 'csv'


#Class of TimeTable list
class TimeTableList
  include Enumerable

  def initialize(file_name)
    @timetable_list = read_data(file_name).map do |item|
      [item.id, item]
    end.to_h
  end

  def read_data(file_name)
    list = []
    id = 1.to_i
    CSV.foreach(file_name, headers: true) do |row|
      timetable_item = TimeTable.new(
        id: id,
        day: row['DAY'],
        number_pair: row['NUMBER_PAIR'],
        subject: row['SUBJECT'],
        teacher: row['TEACHER'],
        audience: row['AUDIENCE'],
        group: row['GROUP']
      )
      id += 1
      list.append(timetable_item)
    end
    list
  end

  def data_by_day_of_week
    hash = Hash.new { |hash, key| hash[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.day].append(elem)
    end
    hash
  end 

  def data_by_teachers
    hash = Hash.new { |hash, key| hash[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.teacher].append(elem)
    end
    hash
  end

  def data_by_groups
    hash = Hash.new { |hash, key| hash[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.group].append(elem)
    end
    hash
  end

  def all_items
    @books.values
  end

  def timetable_by_id(id)
    @timetable_list[id]
  end

  def add_item(params)
    id = @timetable_list.keys.max + 1
    @timetable_list[id] = TimeTable.new(
      id: id,
      day: params[:day],
      number_pair: params[:number_pair],
      subject: params[:subject],
      teacher: params[:teacher],
      audience: params[:audience],
      group: params[:group]
    )
    id
  end

  def update_item(id, params)
    timetable = @timetable_list[id]
    timetable.day = params[:day]
    timetable.number_pair = params[:number_pair]
    timetable.subject = params[:subject]
    timetable.teacher = params[:teacher]
    timetable.audience = params[:audience]
    timetable.group = params[:group]
  end

  def delete_item(id)
    @timetable_list.delete(id)
  end

  def sorted_by_number_of_audience(list)
    new_array = list.sort do |a, b|
      a.audience_number.to_i <=> b.audience_number.to_i
    end
    new_array 
  end

  def each
    @timetable_list.each do |element|
      yield element
    end
  end
end
