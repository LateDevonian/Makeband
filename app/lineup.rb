require 'sinatra/base'
require 'json'
require_relative 'member'
require_relative 'person'
require 'byebug'
require 'ox'
require 'pry'


module  Lineup
  class API < Sinatra::Base
    #api for the lineup : which individual is in what band

    def initialize(member: Member.new)
      @member = member
      super()
    end

    def parse_lineup(request)
      case request.media_type
        when 'text/xml'
          nil
        when 'application/json', 'application/x-www-form-urlencoded', ''
          JSON.parse(request.body.read)
        else
          nil
      end
    end


    post '/lineups' do
      lineup = parse_lineup(request)
      #byebug
      result = @member.record(lineup)

      if result.success?
        JSON.generate('lineup_id' => result.lineup_id)
        else
          status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/lineups/:instrument' do
      JSON.generate(@member.instrument_on(params[:instrument]))
    end
  end
end
