require_relative '../config/sequel'
require 'byebug'
#class that creates/manages the band

module SpiceGirls
  RecordResult = Struct.new(:success?, :band_id, :error_message)

  class Manage
    def record(band)

      band_keys = ['bandname', 'manager', 'gimmick', 'style', 'country_origin', 'bandformed' ]

      band_keys.each do |key|
        unless band.key? key
          message = "Invalid band: '#{key}' is required "
          return RecordResult.new(false, nil, message)
        end
      end

      DB[:bands].insert(band)
      id = DB[:bands].max(:id)
      RecordResult.new(true, id, nil)

    end

    def bandname_on(bandname)
      DB[:bands].where(bandname: bandname).all
    end

    def style_on(style)
      DB[:bands].where(style: style).all
    end

    def manager_on(manager)
        DB[:bands].where(manager: manager).all
    end

    def gimmick_on(gimmick)
        DB[:bands].where(gimmick: gimmick).all
    end
    def bandformed_on(bandformed)
        DB[:bands].where(bandformed: bandformed).all
    end

    def country_origin_on(country_origin)
        DB[:bands].where(country_origin: country_origin).all
    end

  end
end
