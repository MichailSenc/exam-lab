# frozen_string_literal: true

require_relative 'timetable'
require_relative 'timetable_module_new_items'
require_relative 'timetable_module_for_week'
require_relative 'timetable_module_retake'
require_relative 'timetable_module_load'
require_relative 'timetable_module_question'
require_relative 'days_of_the_week'

# Class of TimeTable list
class TimeTableList
  attr_reader :timetable_list
  include Enumerable
  include DataCheckingModule
  include ForWeekModule
  include LoadModule
  include QuestionModule
  include RetakeModule

  def initialize(timetable_list = [])
    @timetable_list = timetable_list.map do |item|
      [item.id, item]
    end.to_h
  end

  def data_by_day_of_week
    hash = Hash.new { |h, key| h[key] = [] }
    DaysWeek.all_days.each { |day| hash[day] }
    @timetable_list.each_value do |elem|
      hash[elem.day].append(elem)
    end
    hash
  end

  def all_data
    hash = Hash.new do |h, key|
      h[key] = Hash.new { |hash1, key1| hash1[key1] = [] }
    end
    DaysWeek.all_days.each { |day| hash[day] }
    @timetable_list.each_value do |elem|
      hash[elem.day][elem.number_pair].append(elem)
    end
    hash
  end

  def move_audience?(params)
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      return true if elem.day.eql?(params[:day]) &&
                     elem.number_pair.eql?(params[:number_pair]) &&
                     elem.audience.eql?(params[:audience]) &&
                     !elem.teacher.eql?(params[:teacher])
    end
    false
  end

  def move_pair?(params)
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      return true if elem.day.eql?(params[:day]) &&
                     elem.number_pair.eql?(params[:number_pair]) &&
                     elem.group.eql?(params[:group])
    end
    false
  end

  def all_items
    @timetable_list.values
  end

  def timetable_by_id(id)
    @timetable_list[id]
  end

  def add_item(params)
    id = if @timetable_list.empty?
           1
         else
           @timetable_list.keys.max + 1
         end
    @timetable_list[id] = TimeTable.new(id: id, **params.to_h)
    id
  end

  def add_real_item(item)
    @timetable_list[item.id] = item
  end

  def move_item(id, params)
    timetable = @timetable_list[id]
    timetable.day = params[:day]
    timetable.number_pair = params[:number_pair]
    timetable.audience = params[:audience]
  end

  def delete_item(id)
    @timetable_list.delete(id)
  end

  def sorted_by_number_of_audience
    array = all_data
    array.delete_if { |_key, value| value.empty? }
    array.each_value do |value|
      value.each_value do |item|
        item.sort! { |a, b| a.audience.to_i <=> b.audience.to_i }
      end
    end
    array
  end

  def each
    @timetable_list.each do |element|
      yield element
    end
  end
end
