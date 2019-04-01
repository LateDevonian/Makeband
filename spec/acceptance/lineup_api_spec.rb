require 'rack/test'
require 'json'
require_relative '../../app/lineup'

module Lineup
  RSpec.describe 'Member API', :db do
    include Rack::Test::Methods

    def app
      Lineup::API.new

    end

    def post_lineup(lineup)

      post '/lineups', JSON.generate(lineup)
      expect(last_response.status).to eq(200)


      parsed = JSON.parse(last_response.body)

      expect(parsed).to include("lineup_id" => a_kind_of(Integer))
      lineup.merge("id" => parsed["lineup_id"])

    end

    it 'records submitted lineup' do
      spicegirls1 = post_lineup(
        'girl_id' => 123,
        'band_id' => 456,
        'bandrole' => 'Lead Melody',
        'instrument' => 'Voice'
        )

        spicegirls2 = post_lineup(
          'girl_id' => 1888,
          'band_id' => 456,
          'bandrole' => 'Backup Singer',
          'instrument' => 'Humming'
          )

        spicegirls3 = post_lineup(
          'girl_id' => 18,
          'band_id' => 456,
          'bandrole' => 'Solo',
          'instrument' => 'Falsetto'
          )

      get '/lineups/Voice'
      expect(last_response.status).to eq(200)

      returned_lineup = JSON.parse(last_response.body)
      expect(returned_lineup).to contain_exactly(spicegirls1)
    end
  end


end
