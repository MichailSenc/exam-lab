# frozen_string_literal: true

# routes timetable
class TimeTableApp
  hash_branch('timetable') do |r|
    append_view_subdir('timetable')
    set_layout_options(template: '../views/layout')

    r.is do
      @time_table_items = opts[:time_table_items].sorted_by_number_of_audience
      view('timetable')
    end

    r.on Integer do |id|
      @timetable = opts[:time_table_items].timetable_by_id(id)

      next if @timetable.nil?

      r.is do
        view('timetable_info')
      end

      r.on 'move' do
        r.get do
          @params = @timetable.to_h
          view('timetable_move')
        end

        r.post do
          @params = DryResultFormeAdapter.new(MoveSchema.new(timetable_list: opts[:time_table_items]).call(r.params), ob: @timetable)
          if @params.success?
            opts[:time_table_items].move_item(@timetable.id, @params)
            r.redirect "/timetable/#{@timetable.id}"
          else
            view('timetable_move')
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
        view('timetable_new')
      end

      r.post do
        @params = DryResultFormeAdapter.new(NewItemSchema.new(timetable_list: opts[:time_table_items]).call(r.params))
        if @params.success?
          opts[:time_table_items].add_item(@params)
          r.redirect '/timetable'
        else
          view('timetable_new')
        end
      end
    end

    r.on 'for_week' do
      @teachers = opts[:time_table_items].all_teachers
      @groups = opts[:time_table_items].all_groups
      @audience = opts[:time_table_items].all_audience

      r.get do
        @params = {}
        view('for_week')
      end

      r.post do
        @params = DryResultFormeAdapter.new(ForWeekSchema.new(timetable_list: opts[:time_table_items]).call(r.params))
        @filtered_items = opts[:time_table_items].for_week_filter(r.params) if @params.success?
        view('for_week')
      end
    end

    r.on 'retake' do
      @teachers = opts[:time_table_items].all_teachers

      r.get do
        @params = {}
        view('retake')
      end

      r.post do
        @params = DryResultFormeAdapter.new(RetakeSchema.new(timetable_list: opts[:time_table_items]).call(r.params))
        @retake_days = opts[:time_table_items].retake_days(r.params) if @params.success?
        view('retake')
      end
    end

    r.on 'question' do
      @teachers = opts[:time_table_items].all_teachers
      @groups = opts[:time_table_items].all_groups

      r.get do
        @params = {}
        view('question')
      end

      r.post do
        @params = DryResultFormeAdapter.new(QuestionSchema.call(r.params))
        @question_days = opts[:time_table_items].question_days(r.params) if @params.success?
        pp @question_days
        view('question')
      end
    end

    r.on 'load' do
      @teachers = opts[:time_table_items].all_teachers
      @params = {}

      r.get do
        view('load')
      end

      r.post do
        @params = DryResultFormeAdapter.new(LoadSchema.call(r.params))
        @load = opts[:time_table_items].load(r.params) if @params.success?
        view('load')
      end
    end
  end
end
