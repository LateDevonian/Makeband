require 'sinatra/base'
require 'json'
require_relative 'manage'
require 'byebug'
require 'ox'
require 'pry'

module SpiceGirls
  #creates the api to create the band
  class API < Sinatra::Base

    def initialize(manage: Manage.new)
      @manage = manage
      super()
    end

    def parse_band(request)
      case request.media_type
        when 'text/xml'
          nil
        when 'application/json', 'application/x-www-form-urlencoded', ''
          JSON.parse(request.body.read)
        else
          nil
      end
    end


    post '/bands' do
      band = parse_band(request)
      #byebug
      result = @manage.record(band)

      if result.success?
        JSON.generate('band_id' => result.band_id)
        else
          status 422
        JSON.generate('error' => result.error_message)
      end
    end


    get '/bands/:bandname' do
      JSON.generate(@manage.bandname_on(params[:bandname]))
    end
  end
end
