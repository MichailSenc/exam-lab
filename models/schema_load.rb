# frozen_string_literal: true

require 'dry-schema'

require_relative 'schema_types'

LoadSchema = Dry::Schema.Params do
  required(:teacher).filled(SchemaTypes::StrippedString)
end
