require 'rack/test'
require 'json'
require_relative '../../app/girl'

module Bandmember
  RSpec.describe 'Person API', :db do
    include Rack::Test::Methods

    def app
      Bandmember::API.new

    end

    def post_girl(girl)

      post '/girls', JSON.generate(girl)
      expect(last_response.status).to eq(200)


      parsed = JSON.parse(last_response.body)

      expect(parsed).to include("girl_id" => a_kind_of(Integer))
      girl.merge("id" => parsed["girl_id"])

    end

    it 'records submitted girls' do
      sportyspice = post_girl(
        'firstname' => 'Melanie',
        'surname' => 'Chisholm',
        'nickname' => 'Sporty',
        'quirk' => 'Tracksuits',
        'dob' => '1994-01-01'
        )

        babyspice = post_girl(
          'firstname' => 'Emma',
          'surname' => 'Bunton',
          'nickname' => 'Baby',
          'quirk' => 'Babydoll',
          'dob' => '1994-11-11'
          )

        gingerspice = post_girl(
          'firstname' => 'Geri',
          'surname' => 'Halliwell',
          'nickname' => 'Ginger',
          'quirk' => 'Organise',
          'dob' => '1994-01-01'
        )

      get '/girls/Sporty'
      expect(last_response.status).to eq(200)

      returned_girl = JSON.parse(last_response.body)
      expect(returned_girl).to contain_exactly(sportyspice)
    end
  end


end
