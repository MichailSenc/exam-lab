# frozen_string_literal: true

# the module contains functions for working with 'retake' data. 4 task
module RetakeModule
  def retake_days(params)
    data = all_data
    teacher = params['teacher']
    groups = params['groups'].split(' ')

    retake = retake_by_teacher(teacher, data) & retake_by_groups(groups, data)
    return nil if retake.empty?

    retake.each do |day|
      auditory = retake_by_audience(day, data, teacher)
      return day.append(auditory[0]) if !auditory.empty?
    end
    nil
  end

  def retake_by_teacher(teacher, data)
    days = []
    data.each do |key, day|
      (1..5).each do |i|
        if day.key?(i)
          next if check_for_teacher(day[i], teacher)
        end
        if day.key?(i + 1)
          next if check_for_teacher(day[i + 1], teacher)
        end
        key = day.each_key
        days.append([day[key.first][0].day, i, i + 1])
      end
    end
    days
  end

  def check_for_teacher(day, teacher)
    day.each do |item|
      return true if item.teacher.eql?(teacher)
    end
    false
  end

  def retake_by_audience(day, data, teacher)
    all_audience = all_audience_by_teacher(teacher)
    data[day[0]][day[1]].each do |item|
      all_audience.delete(item.audience)
    end

    data[day[0]][day[2]].each do |item|
      all_audience.delete(item.audience)
    end
    all_audience
  end

  def retake_by_groups(groups, data)
    days = []
    data.each do |key, day|
      (1..5).each do |i|
        if day.key?(i)
          next if check_for_groups(day[i], groups)
        end
        if day.key?(i + 1)
          next if check_for_groups(day[i + 1], groups)
        end
        key = day.each_key
        days.append([day[key.first][0].day, i, i + 1])
      end
    end
    days
  end

  def check_for_groups(day, groups)
    day.each do |item|
      return true if groups.map { |group| item.group.eql?(group) }.include?(true)
    end
    false
  end

  def groups?(param)
    errors = []
    all = all_groups
    groups = param.split(' ')
    groups.each do |group|
      errors.concat([group]) if !all.include?(group)
    end
    errors.uniq
  end

  def all_audience_by_teacher(teacher)
    array = []
    @timetable_list.each_value do |value|
      array.append(value.audience) if value.teacher.eql?(teacher)
    end
    array.uniq
  end
end
