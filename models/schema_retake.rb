# frozen_string_literal: true

require 'dry-schema'
require 'dry-validation'

require_relative 'schema_types'
require_relative 'days_of_the_week'

# validator to add new timetable item
class RetakeSchema < Dry::Validation::Contract
  option :timetable_list

  params do
    required(:teacher).filled(SchemaTypes::StrippedString)
    required(:groups).filled(SchemaTypes::StrippedString)
  end

  rule(:groups) do
    errors = timetable_list.groups?(values[:groups])
    errors[0] = "invalid groups: #{errors[0]}" if !errors.empty?
    errors.each do |error|
      key(:groups).failure(error)
    end
  end

  rule(:teacher) do
    if !timetable_list.all_teachers.include?(values[:teacher])
      key(:teacher).failure('Данного преподавателя не существует.')
    end
  end
end
