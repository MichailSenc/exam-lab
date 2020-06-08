# frozen_string_literal: true

# the module contains functions for working with 'questions' data. 7 task
module QuestionModule
  def question_days(param)
    data = all_data
    date_array = []
    data.each do |day, pairs|
      (1..6).each do |i|
        next if teacher_in_the_corps(param['teacher'], pairs)
        next if group_in_the_corps(param['group'], pairs)

        if teacher_is_present(param['teacher'], pairs, i) && group_is_present(param['group'], pairs, i)
          date_array.append([day, i])
        end
      end
    end
    date_array
  end

  def teacher_in_the_corps(teacher, pairs)
    pairs.each_value do |pair|
      pair.each do |item|
        return false if item.teacher.downcase.eql?(teacher.downcase)
      end
    end
    true
  end

  def teacher_is_present(teacher, pairs, key)
    return true if !pairs.key?(key)

    pairs[key].each do |item|
      return false if item.teacher.eql?(teacher)
    end
    true
  end

  def group_in_the_corps(group, pairs)
    pairs.each_value do |pair|
      pair.each do |item|
        return false if item.group.downcase.eql?(group.downcase)
      end
    end
    true
  end

  def group_is_present(group, pairs, key)
    return true if !pairs.key?(key)

    pairs[key].each do |item|
      return false if item.group.downcase.eql?(group.downcase)
    end
    true
  end
end
