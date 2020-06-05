# frozen_string_literal: true

# the module contains functions to working and checking data "PER WEEK". 4 task
module ForWeekModule
  def all_groups
    array = []
    @timetable_list.each_value do |value|
      array.append(value.group)
    end
    array.uniq.sort
  end

  def all_teachers
    array = []
    @timetable_list.each_value do |value|
      array.append(value.teacher)
    end
    array.uniq.sort
  end

  def all_audience
    array = []
    @timetable_list.each_value do |value|
      array.append(value.audience)
    end
    array.uniq.sort
  end

  def for_week_filter(params)
    filtered_hash = {}
    case params['choice']
    when 'Преподаватель'
      filtered_hash = filter_by_teacher(params['teacher'].strip)
    when 'Группа'
      filtered_hash = filter_by_group(params['group'].strip)
    when 'Аудитория'
      filtered_hash = filter_by_audience(params['audience'].strip)
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
