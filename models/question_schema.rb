# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

QuestionSchema = Dry::Schema.Params do
  required(:teacher).filled(SchemaTypes::StrippedString)
  required(:group).filled(SchemaTypes::StrippedString)
end
