# frozen_string_literal: true

require 'forwardable'
require_relative 'timetable'
require 'csv'

# Class of TimeTable list
class TimeTableList
  include Enumerable

  def initialize(timetable_list = [])
    @timetable_list = timetable_list.map do |item|
      [item.id, item]
    end.to_h
  end

  def data_by_day_of_week
    h = Hash.new { |hash, key| hash[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.day].append(elem)
    end
    h
  end

  def data_by_teachers
    h = Hash.new { |hash, key| hash[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.teacher].append(elem)
    end
    h
  end

  def data_by_groups
    h = Hash.new { |hash, key| hash[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.group].append(elem)
    end
    h
  end

  def all_items
    @timetable_list.values
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

  def add_real_item(item)
    @timetable_list[item.id] = item
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
