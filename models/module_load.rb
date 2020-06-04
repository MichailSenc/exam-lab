# frozen_string_literal: true

# module contains methods to working with "LOAD" data. 8 task
module LoadModule
  def load(params)
    hash = {}
    hash[:hours] = loag_hours(params['teacher'])
    hash[:uniq_subjects] = load_uniq_subjects(params['teacher'])
    hash[:groups] = load_groups(params['teacher'])
    hash
  end

  def loag_hours(teacher)
    load = 0
    @timetable_list.each_value do |item|
      load += 1.5 if item.teacher.eql?(teacher)
    end
    load
  end

  def load_uniq_subjects(teacher)
    uniq_subjects = []
    @timetable_list.each_value do |item|
      uniq_subjects.append(item.subject) if item.teacher.eql?(teacher)
    end
    uniq_subjects.uniq
  end

  def load_groups(teacher)
    load_groups = []
    @timetable_list.each_value do |item|
      load_groups.append(item.group) if item.teacher.eql?(teacher)
    end
    load_groups.uniq.size
  end
end
