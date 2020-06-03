# frozen_string_literal: true

# module adding methods for checking input data
module DataChecking
  def group?(params)
    errors = []
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      if elem.number_pair.eql?(params[:number_pair]) && elem.group.eql?(params[:group])
        errors.concat(['В любой момент времени группа должна быть максимум на одном занятии'])
        pp elem
      end
    end
    errors
  end

  def teacher?(params)
    errors = []
    errors.concat(['Общее число предметов у преподавателя не должно превышать 8 штук']) if check_1(params)
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      if check_2(params, elem)
        errors.concat(['В любой момент времени преподаватель должен вести максимум один предмет'])
        pp elem
      end
      if check_3(params, elem)
        errors.concat(['В любой момент времени преподаватель должен находиться максимум в одном месте'])
        pp elem
      end
    end
    errors
  end

  def audience?(params)
    errors = []
    data = data_by_day_of_week[params[:day]]
    data.each do |elem|
      if check_4(params, elem)
        errors.concat(['В любой момент времени в аудитории может преподаваться максимум один предмет'])
        pp elem
      end
      if check_5(params, elem)
        errors.concat(['В любой момент времени в аудитории может находиться максимум одним преподаватель'])

      end
    end
    errors
  end

  def check_1(params)
    !@number_teachers_subject.include?(params[:subject]) &&
      @number_teachers_subject.uniq.length >= 8
  end

  def check_2(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.teacher.eql?(params[:teacher]) &&
      !elem.subject.eql?(params[:subject])
  end

  def check_3(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.teacher.eql?(params[:teacher]) &&
      !elem.audience.eql?(params[:audience])
  end

  def check_4(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.audience.eql?(params[:audience]) &&
      !elem.subject.eql?(params[:subject])
  end

  def check_5(params, elem)
    elem.number_pair.eql?(params[:number_pair]) &&
      elem.audience.eql?(params[:audience]) &&
      !elem.teacher.eql?(params[:teacher])
  end
end
