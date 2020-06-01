# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'
require_relative 'days_of_the_week'

NewSchema = Dry::Schema.Params do
  required(:day).filled(SchemaTypes::StrippedString, included_in?: DaysWeek.all_days)
  required(:number_pair).filled(:integer, gteq?: 1, lteq?: 6)
  required(:subject).filled(SchemaTypes::StrippedString)
  required(:teacher).filled(SchemaTypes::StrippedString)
  required(:audience).filled(:integer, gteq?: 0)
  required(:group).filled(SchemaTypes::StrippedString)
end
