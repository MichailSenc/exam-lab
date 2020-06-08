# frozen_string_literal: true

require 'dry-schema'
require 'dry-validation'

require_relative 'schema_types'
require_relative 'days_of_the_week'

# validator to add new timetable item
class MoveSchema < Dry::Validation::Contract
  option :timetable_list

  params do
    required(:day).filled(SchemaTypes::StrippedString, included_in?: DaysWeek.all_days)
    required(:number_pair).filled(:integer, gteq?: 1, lteq?: 6)
    required(:audience).filled(:integer, gteq?: 0)
    required(:teacher).filled(SchemaTypes::StrippedString)
    required(:group).filled(SchemaTypes::StrippedString)
  end

  rule(:day, :number_pair, :audience, :group, :teacher) do
    pp values
    if timetable_list.move_audience?(values)
      key(:audience).failure('Данная аудитория уже занята другим преподавателем.')
    end

    key(:number_pair).failure('В данное время у группы есть друга пара.') if timetable_list.move_pair?(values)
  end
end
