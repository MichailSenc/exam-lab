# frozen_string_literal: true

require_relative 'timetable'
require_relative 'module_new_items'
require_relative 'module_for_week'
require_relative 'module_retake'
require_relative 'module_load'
require_relative 'days_of_the_week'

# Class of TimeTable list
class TimeTableList
  attr_reader :timetable_list
  include Enumerable
  include DataCheckingModule
  include ForWeekModule
  include RetakeModule
  include LoadModule

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

  def move?(params)
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      return true if elem.day.eql?(params[:day]) &&
                     elem.number_pair.eql?(params[:number_pair]) &&
                     elem.audience.eql?(params[:audience])
    end
    false
  end

  def question_days(_params)
    data = data_by_day_of_week
    true
  end

  def question_by_teacher(teacher, data)
    date_array = []
    data.each do |item|
      date_array.append([item.day, item.number_pair]) if item.teacher.eql?(teacher)
    end
  end

  def all_items
    @timetable_list.values
  end

  def timetable_by_id(id)
    @timetable_list[id]
  end

  def add_item(params)
    if @timetable_list.empty?

    end
    id = 1
    id = @timetable_list.keys.max + 1 if !@timetable_list.empty?
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
