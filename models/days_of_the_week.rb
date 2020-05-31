module DaysWeek
    SUNDAY = 'Воскресенье'
    MONDAY = 'Понедельник'
    TUESDAY = 'Вторник'
    WEDNESDAY = 'Среда'
    THURSDAY = 'Четверг'   
    FRIDAY = 'Пятница'
    SATURDAY = 'Суббота'    

    def self.all_days
        [
            MONDAY, TUESDAY , WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
        ]
    end
end