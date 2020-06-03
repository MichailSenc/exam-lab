# frozen_string_literal: true

require 'dry-schema'

# scema for delet timetable item
DeleteSchema = Dry::Schema.Params do
  required(:confirmation).filled(true)
end
