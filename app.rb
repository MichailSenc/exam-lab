# frozen_string_literal: true

require 'forme'
require 'roda'
require_relative 'models'

# class diary(main)
class TimeTableApp < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :hash_routes
  plugin :path
  plugin :render
  plugin :status_handler
  plugin :view_options

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  opts[:store] = Store.new
  opts[:time_table_items] = opts[:store].timetable
  opts[:for_week] = {}

  status_handler(404) do
    view 'not_found'
  end

  validation_for_new_items = ValidSchema.new(timetable_list: opts[:time_table_items])
  for_week_validation = ForWeekSchema.new(timetable_list: opts[:time_table_items])

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

      r.on Integer do |id|
        @timetable = opts[:time_table_items].timetable_by_id(id)
        next if @timetable.nil?

        r.is do
          view('timetable_info')
        end

        r.on 'edit' do
          r.get do
            @params = @timetable.to_h
            view('timetable_edit')
          end

          r.post do
            # @params = DryResultFormeAdapter.new(NewSchema.call(r.params))
            @params = DryResultFormeAdapter.new(validation_for_new_items.call(r.params))
            if @params.success?
              opts[:time_table_items].update_item(@timetable.id, @params)
              r.redirect "/timetable/#{@timetable.id}"
            else
              view('timetable_edit')
            end
          end
        end

        r.on 'delete' do
          r.get do
            @params = {}
            view('timetable_delete')
          end

          r.post do
            @params = DryResultFormeAdapter.new(DeleteSchema.call(r.params))
            if @params.success?
              opts[:time_table_items].delete_item(@timetable.id)
              r.redirect('/timetable')
            else
              view('timetable_delete')
            end
          end
        end
      end

      r.on 'new' do
        r.get do
          @params = {}
          view('add_new_item')
        end

        r.post do
          # @params = DryResultFormeAdapter.new(NewSchema.call(r.params))
          @params = DryResultFormeAdapter.new(validation_for_new_items.call(r.params))
          # pp validation_for_new_items.call(r.params).errors
          if @params.success?
            opts[:time_table_items].add_item(@params)
            r.redirect '/timetable'
          else
            view('add_new_item')
          end
        end
      end
    end
  end
end
