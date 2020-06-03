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
    hash = Hash.new { |h, key| h[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.day].append(elem)
    end
    hash
  end

  def group?(param_group, param_day, param_number_pair)
    data = data_by_day_of_week[param_day]
    data.each do |elem|
      if elem.number_pair.eql?(param_number_pair) && elem.group.eql?(param_group)
        pp elem
        return true
      end
    end
    false
  end

  def teacher?(param_teacher, param_day, param_number_pair)
    data = data_by_day_of_week[param_day]
    data.each do |elem|
      if elem.number_pair.eql?(param_number_pair) && elem.teacher.eql?(param_teacher)
        pp elem
        return true
      end
    end
    false
  end

  def audience?(param_audience, param_day, param_number_pair)
    data = data_by_day_of_week[param_day]
    data.each do |elem|
      if elem.number_pair.eql?(param_number_pair) && elem.audience.eql?(param_audience)
        pp elem
        return true
      end
    end
    false
  end

  def for_week?(_param_data, _param_choice)
    false
  end

  def for_week_data(choice, data)
    hash = {}
    date = Hash.new { |h, key| h[key] = [] }
    if choice.eql?('Преподаватель')
      data_by_day_of_week.each do |_key, value|
        value.each do |elem|
          date[:elem.number_pair].append(elem) if elem.teacher.eql?(data)
        end
        hash[:key] = date
      end
    end
    if choice.eql?('Группа')
      data_by_day_of_week.each do |key, value|
        value.each do |elem|
          hash[key].append(elem) if elem.group.eql?(data)
        end
      end
    end
    if choice.eql?('Аудитория')
      data_by_day_of_week.each do |key, value|
        value.each do |elem|
          hash[key].append(elem) if elem.audience.eql?(data)
        end
      end
    end
    hash
  end

  def all_teachers
    array = []
    @timetable_list.each_value do |value|
      array.append(value.teacher)
    end
    array.uniq
  end

  def all_groups
    array = []
    @timetable_list.each_value do |value|
      array.append(value.group)
    end
    array.uniq
  end

  def all_audiences
    array = []
    @timetable_list.each_value do |value|
      array.append(value.audience)
    end
    array.uniq
  end

  def data_by_teachers
    hash = Hash.new { |h, key| h[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.teacher].append(elem)
    end
    hash
  end

  def data_by_groups
    hash = Hash.new { |h, key| h[key] = [] }
    @timetable_list.each_value do |elem|
      hash[elem.group].append(elem)
    end
    hash
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
