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
    required(:choice).filled(:string)
  end

  rule(:data, :choice) do
    key(:data).failure('Incorrect data') if timetable_list.for_week?(values[:data], values[:choice])
  end
end
