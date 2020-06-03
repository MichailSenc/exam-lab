# frozen_string_literal: true

# the module contains functions for working and checking data "per week". 4 task
module ForWeekModule
  def for_week_teacher?(teacher)
    @timetable_list.each_value do |value|
      return false if value.teacher.eql?(teacher)
    end
    true
  end

  def for_week_group?(group)
    @timetable_list.each_value do |value|
      return false if value.group.eql?(group)
    end
    true
  end

  def for_week_audience?(audience)
    @timetable_list.each_value do |value|
      return false if value.audience.to_i == audience.to_i
    end
    true
  end

  def for_week_filter(params)
    filtered_hash = {}
    case params['choice']
    when 'Преподаватель'
      filtered_hash = filter_by_teacher(params['data'].strip)
    when 'Группа'
      filtered_hash = filter_by_group(params['data'].strip)
    when 'Аудитория'
      filtered_hash = filter_by_audience(params['data'].strip)
    end
    filtered_hash
  end

  def filter_by_teacher(teacher)
    data = data_by_day_of_week
    filtered_hash = Hash.new { |h, key| h[key] = [{}, []] }
    DaysWeek.all_days.each do |day|
      hash = {}
      groups = []
      data[day].each do |item|
        if item.teacher.eql?(teacher)
          hash[item.number_pair] = item
          groups.concat([item.group])
        end
      end
      filtered_hash[day][0] = hash
      filtered_hash[day][1] = groups.uniq
    end
    filtered_hash
  end

  def filter_by_group(group)
    data = data_by_day_of_week
    filtered_hash = Hash.new { |h, key| h[key] = [{}, []] }
    DaysWeek.all_days.each do |day|
      hash = {}
      groups = []
      data[day].each do |item|
        if item.group.eql?(group)
          hash[item.number_pair] = item
          groups.concat([item.group])
        end
      end
      filtered_hash[day][0] = hash
      filtered_hash[day][1] = groups.uniq
    end
    filtered_hash
  end

  def filter_by_audience(audience)
    data = data_by_day_of_week
    filtered_hash = Hash.new { |h, key| h[key] = [{}, []] }
    DaysWeek.all_days.each do |day|
      hash = {}
      groups = []
      data[day].each do |item|
        if item.audience.to_i == audience.to_i
          hash[item.number_pair] = item
          groups.concat([item.group])
        end
      end
      filtered_hash[day][0] = hash
      filtered_hash[day][1] = groups.uniq
    end
    filtered_hash
  end
end
