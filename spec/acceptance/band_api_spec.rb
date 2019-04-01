require 'rack/test'
require 'json'
require_relative '../../app/band'

module SpiceGirls
  RSpec.describe 'Band API', :db do
  include Rack::Test::Methods

    def app
      SpiceGirls::API.new

    end

    def post_band(band)

      post '/bands', JSON.generate(band)
      expect(last_response.status).to eq(200)


      parsed = JSON.parse(last_response.body)

      expect(parsed).to include("band_id" => a_kind_of(Integer))
      band.merge("id" => parsed["band_id"])

    end

    it 'records submitted bands' do
      britpop = post_band(
        'bandname' => 'SpiceGirls',
        'manager' => 'Bob Fossil',
        'gimmick' => 'GirlBand',
        'style' => '90s Britpop',
        'country_origin' => 'UK',
        'bandformed' => '1996-05-05'
        )

      british_metal = post_band(
        'bandname' => 'Iron Maiden',
        'manager' => 'Bruce the Pilot',
        'gimmick' => 'Riffs and Melody',
        'style' => 'Classic heavy metal',
        'country_origin' => 'UK',
        'bandformed' => '1974-01-11'
      )

      rock = post_band(
        'bandname' => 'Faith No More',
        'manager' => 'Enoch Root',
        'gimmick' => 'Every album different',
        'style' => 'Rock, nu-rock, metal',
        'country_origin' => 'USA',
        'bandformed' => '1998-10-11'
      )

      get '/bands/SpiceGirls'
      expect(last_response.status).to eq(200)

      returned_band = JSON.parse(last_response.body)
      expect(returned_band).to contain_exactly(britpop)
    end
  end
end
