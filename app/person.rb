require 'byebug'
require_relative '../config/sequel'


module Bandmember
  RecordResult = Struct.new(:success?, :girl_id, :error_message)
  #creates the indivual artist. need to take out gender assumptions
  class Person
    def record(girl)

      girl_keys = ['firstname', 'surname', 'nickname', 'quirk', 'dob' ]

      girl_keys.each do |key|
        unless girl.key? key
          message = "Invalid member: '#{key}' is required "
          return RecordResult.new(false, nil, message)
        end
      end

      DB[:girls].insert(girl)
      id = DB[:girls].max(:id)
      RecordResult.new(true, id, nil)
    end

    def girl_exist?(girl_id)
      whole_table = DB[:girls].all
      if
        whole_table == []
         false
        else true
      end
    end

    def return_girl(girl_id)
      girl_data = DB[:girls].where(id: girl_id).all
    end


    def update_girl(girl_key, girl_id, new_key_value)

      is_girl_valid = girl_exist?(girl_id)
      unless is_girl_valid == true
        message = "Invalid item: person is invalid"
        return RecordResult.new(false, nil, message)
      end

      whole_table = DB[:girls]
      case girl_key
        when 'firstname'
         whole_table.where(:id => girl_id).update(:firstname => new_key_value)
         return RecordResult.new(true, new_key_value, nil)

        when 'surname'
        whole_table.where(:id => girl_id).update(:surname => new_key_value)
        return RecordResult.new(true, new_key_value, nil)

        when 'nickname'
         whole_table.where(:id => girl_id).update(:nickname => new_key_value)
         return RecordResult.new(true, new_key_value, nil)

         when 'quirk'
         whole_table.where(:id => girl_id).update(:quirk => new_key_value)
         return RecordResult.new(true, new_key_value, nil)

        when 'dob'
         whole_table.where(:id => girl_id).update(:dob => new_key_value)
         return RecordResult.new(true, new_key_value, nil)

        else
         message = "Invalid item: '#{girl_key}' is invalid "
         return RecordResult.new(false, nil, message)
       end
     end

    def nickname_on(nickname)
      DB[:girls].where(nickname: nickname).all
    end

    def firstname_on(firstname)
      DB[:girls].where(firstname: firstname).all
    end

    def surname_on(surname)
      DB[:girls].where(surname: surname).all
    end

    def quirk_on(quirk)
      DB[:girls].where(quirk: quirk).all
    end

    def joinedband_on(dob)
      DB[:girls].where(dob: dob).all
    end
  end

  end
