# frozen_string_literal: true

require 'dry-schema'
require 'dry-validation'

require_relative 'schema_types'
require_relative 'days_of_the_week'
# week validator
class ForWeekSchema < Dry::Validation::Contract
  option :timetable_list

  params do
    required(:data).filled(SchemaTypes::StrippedString)
    required(:choice).filled(SchemaTypes::StrippedString, included_in?: DaysWeek.timetable_items)
  end

  rule(:data, :choice) do
    case values[:choice]
    when 'Преподаватель'
      key(:data).failure('Данного преподавателя не существует') if timetable_list.for_week_teacher?(values[:data])
    when 'Группа'
      key(:data).failure('Данной группы не существует') if timetable_list.for_week_group?(values[:data])
    when 'Аудитория'
      key(:data).failure('Данной аудитории не существует') if timetable_list.for_week_audience?(values[:data])
    else
      key(:data).failure('Некорректные данные')
    end
  end
end
