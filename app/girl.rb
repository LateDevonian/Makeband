require 'sinatra/base'
require 'sinatra/multi_route'
require 'json'
require_relative 'person'
require 'byebug'
require 'ox'
require 'pry'

module Bandmember
  class API < Sinatra::Base
    register Sinatra::MultiRoute
    #creates the api to create and update the individual artist

    def initialize(person: Person.new)
      @person = person
      super()
    end


    def parse_girl(request)
      case request.media_type
        when 'text/xml'
          nil
        when 'application/json', 'application/x-www-form-urlencoded', ''
          JSON.parse(request.body.read)
        else
          nil
      end
    end

    post '/girls' do
      #byebug
      girl = parse_girl(request)
      result = @person.record(girl)

      if result.success?
        JSON.generate('girl_id' => result.girl_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    put '/girls/edit' do
      #untested. not sure how to use this
      result = @person.update_girl(request)

      if result.success?
        JSON.generate('girl_id' => result.girl_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end

    end

    get '/girls/:nickname' do
      JSON.generate(@person.nickname_on(params[:nickname]))
    end

    get '/girls/:firstname' do
      JSON.generate(@person.firstname_on(params[:firstname]))
    end

    get '/girls/:surname' do
      JSON.generate(@person.surname_on(params[:surname]))
    end

    get '/girls/:quirk' do
      JSON.generate(@person.quirk_on(params[:quirk]))
    end
    get '/girls/:dob' do
      JSON.generate(@person.joinedband_on(params[:dob]))
    end
  end
end
