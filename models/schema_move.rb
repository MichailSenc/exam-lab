# frozen_string_literal: true

require 'dry-schema'
require 'dry-validation'

require_relative 'schema_types'
require_relative 'days_of_the_week'

# validator to add new timetable item
class MoveSchema < Dry::Validation::Contract
  option :timetable_list
  option :ob

  params do
    required(:day).filled(SchemaTypes::StrippedString, included_in?: DaysWeek.all_days)
    required(:number_pair).filled(:integer, gteq?: 1, lteq?: 6)
    required(:audience).filled(:integer, gteq?: 0)
    required(:group).filled(SchemaTypes::StrippedString)
  end

  rule(:day, :number_pair, :audience) do
    key(:audience).failure('В этот день данная аудитория уже занята.') if timetable_list.move_audience?(values)
    key(:number_pair).failure('В .') if timetable_list.move_group?(values, ob.group)
    if timetable_list.move_subj?(values, ob.subject)
      key(:number_pair).failure('В этот день данная аудитория уже занята.')
    end
  end
end
