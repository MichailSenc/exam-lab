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
  end

  rule(:day, :number_pair, :audience) do
    key(:audience).failure('В этот день данная аудитория уже занята.') if timetable_list.move?(values)
  end
end
