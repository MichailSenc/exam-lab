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
    errors = timetable_list.new_group?(values)
    # pp errors
    errors.each do |error|
      key(:group).failure(error)
    end
  end

  rule(:teacher, :day, :number_pair, :subject, :audience) do
    errors = timetable_list.new_teacher?(values)
    # pp errors
    errors.each do |error|
      key(:teacher).failure(error)
    end
  end

  rule(:audience, :day, :number_pair, :subject) do
    errors = timetable_list.new_audience?(values)
    # pp errors
    errors.each do |error|
      key(:audience).failure(error)
    end
  end
end
