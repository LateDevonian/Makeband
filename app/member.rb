require_relative '../config/sequel'
require 'byebug'
#class that creates/manages the member of the band
# written initally for spice girls so need to fix gender assumptions

module Lineup
  RecordResult = Struct.new(:success?, :lineup_id, :error_message)

  class Member
    def record(lineup)

      lineup_keys = ['girl_id', 'band_id', 'bandrole', 'instrument']

      lineup_keys.each do |key|
        unless lineup.key? key
          message = "Invalid lineup: '#{key}' is required "
          return RecordResult.new(false, nil, message)
        end
      end

      DB[:lineups].insert(lineup)
      id = DB[:lineups].max(:id)
      RecordResult.new(true, id, nil)

    end

    #retrieve names from the list. modify.
    def instrument_on(instrument)
        DB[:lineups].where(instrument: instrument).all
    end

    def girl_id_on(girl_id)
      DB[:lineups].where(girl_id: girl_id).all
    end

    def band_id_on(band_id)
      DB[:lineups].where(band_id: band_id).all
    end

    def bandrole_on(bandrole)
        DB[:lineups].where(bandrole: bandrole).all
    end
  end
end
