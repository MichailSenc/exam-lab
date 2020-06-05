# frozen_string_literal: true

require 'dry-schema'
require 'dry-validation'

require_relative 'schema_types'
require_relative 'days_of_the_week'
# week validator
class ForWeekSchema < Dry::Validation::Contract
  option :timetable_list

  params do
    required(:teacher).maybe(SchemaTypes::StrippedString)
    required(:group).maybe(SchemaTypes::StrippedString)
    required(:audience).maybe(SchemaTypes::StrippedString)
    required(:choice).filled(SchemaTypes::StrippedString, included_in?: DaysWeek.timetable_items)
  end

  rule(:teacher, :group, :audience, :choice) do
    case values[:choice]
    when 'Преподаватель'
      if !timetable_list.all_teachers.include?(values[:teacher])
        key(:teacher).failure('Данного преподавателя не существует')
      end
    when 'Группа'
      key(:group).failure('Данной группы не существует') if !timetable_list.all_groups.include?(values[:group])
    when 'Аудитория'
      if !timetable_list.all_audience.include?(values[:audience].to_i)
        key(:audience).failure('Данной аудитории не существует')
      end
    end
  end
end
