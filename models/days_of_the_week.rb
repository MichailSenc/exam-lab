# frozen_string_literal: true

# class of week days
module DaysWeek
  SUNDAY = 'Воскресенье'
  MONDAY = 'Понедельник'
  TUESDAY = 'Вторник'
  WEDNESDAY = 'Среда'
  THURSDAY = 'Четверг'
  FRIDAY = 'Пятница'
  SATURDAY = 'Суббота'

  def self.all_days
    [
      MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
    ]
  end

  TEACHER = 'Преподаватель'
  STUDENT = 'Группа'
  AUDIENCE = 'Аудитория'

  def self.timetable_items
    [
      TEACHER, STUDENT, AUDIENCE
    ]
  end
end
