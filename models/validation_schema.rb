# frozen_string_literal: true

require 'dry-schema'
require 'dry-validation'

require_relative 'schema_types'
require_relative 'days_of_the_week'

# validator to add new timetable item
class ValidSchema < Dry::Validation::Contract
  option :timetable_list

  params do
    required(:day).filled(SchemaTypes::StrippedString, included_in?: DaysWeek.all_days)
    required(:number_pair).filled(:integer, gteq?: 1, lteq?: 6)
    required(:subject).filled(SchemaTypes::StrippedString)
    required(:teacher).filled(SchemaTypes::StrippedString)
    required(:audience).filled(:integer, gteq?: 0)
    required(:group).filled(SchemaTypes::StrippedString)
  end

  rule(:group, :day, :number_pair) do
    pp timetable_list.group?(values[:group], values[:day], values[:number_pair])
    key(:group).failure('fail_group') if timetable_list.group?(values[:group], values[:day], values[:number_pair])
  end

  rule(:teacher, :day, :number_pair) do
    pp timetable_list.teacher?(values[:teacher], values[:day], values[:number_pair])
    if timetable_list.teacher?(values[:teacher], values[:day], values[:number_pair])
      key(:teacher).failure('fail_teacher')
    end
  end

  rule(:audience, :day, :number_pair) do
    pp timetable_list.audience?(values[:audience], values[:day], values[:number_pair])
    if timetable_list.audience?(values[:audience], values[:day], values[:number_pair])
      key(:audience).failure('fail_audience')
    end
  end
end
