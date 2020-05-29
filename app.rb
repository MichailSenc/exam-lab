# frozen_string_literal: true

require 'forme'
require 'roda'
require_relative 'models'

# class diary(main)
class TimeTableApp < Roda
 opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :render

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  opts[:time_table_items] = TimeTableList.new('data/timetable.csv')

  route do |r|
    r.public if opts[:serve_static]

    r.root do 
      r.redirect '/timetable'
    end

    r.on 'timetable' do
      r.is do
        @time_table_items = opts[:time_table_items]
        view('timetable')
      end

      r.on 'new' do
        r.get do
          @params = {}
          view('add_new_item')
        end

        r.post do
          @params = DryResultFormeAdapter.new(NewSchema.call(r.params))
          if @params.success?
            opts[:time_table_items].add_item(TimeTable.new(@params[:day], @params[:number_pair], @params[:subject],
                                           @params[:teacher], @params[:audience], @params[:group]))
            r.redirect '/timetable'
          else
            view('add_new_item')
          end
        end
      end
    end
  end
end
