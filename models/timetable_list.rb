# frozen_string_literal: true

require 'forwardable'
require_relative 'timetable'
require_relative 'modle_for_cheking_new_items'
require_relative 'modle_for_week_time_table'
require_relative 'module_retake'
require_relative 'days_of_the_week'
require 'csv'

# Class of TimeTable list
class TimeTableList
  attr_reader :number_teachers_subject
  include Enumerable
  include DataChecking
  include ForWeekModule
  include RetakeModule

  def initialize(timetable_list = [])
    @timetable_list = timetable_list.map do |item|
      [item.id, item]
    end.to_h
    @number_teachers_subject = Hash.new { |h, key| h[key] = [] }
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

  def all_groups
    array = []
    @timetable_list.each_value do |value|
      array.append(value.group)
    end
    array.uniq
  end

  def all_teachers
    array = []
    @timetable_list.each_value do |value|
      array.append(value.teacher)
    end
    array.uniq
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
    @number_teachers_subject[params[:teacher]].append(params[:subject])
    id
  end

  def add_real_item(item)
    @timetable_list[item.id] = item
    @number_teachers_subject[item.teacher].append(item.subject)
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
    item = @timetable_list.delete(id)
    @number_teachers_subject[item.teacher].delete(item.subject) if item
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
