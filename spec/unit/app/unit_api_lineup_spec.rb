require_relative '../../../app/lineup'
require 'rack/test'
require 'rspec'

module Lineup
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(member: member)
    end

    def response
      JSON.parse(last_response.body)
    end

    let (:member) { instance_double('lineup::member') }

    describe 'POST /lineups' do
      let (:lineup) { { 'some' => 'data'} }

      context 'when the lineup is successfully recorded' do
        before do
          allow(member).to receive(:record)
          .with(lineup)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the lineup id' do
          post '/lineups', JSON.generate(lineup)
          expect(response).to include('lineup_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/lineups', JSON.generate(lineup)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the lineup fails validation' do
        let(:lineup) { { "some" => "data" }}
        before do
          allow(member). to receive(:record)
          .with(lineup)
          .and_return(RecordResult.new(false, 417, 'lineup incomplete'))
        end

        it 'returns an error message' do
          post '/lineups', JSON.generate(lineup)
          expect(response).to include('error' => 'lineup incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/lineups', JSON.generate(lineup)
          expect(last_response.status).to eq(422)
        end
      end

      context 'input data format' do
        before do
          allow(member). to receive(:record)
          .with(lineup)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'is JSON by default' do
          post '/lineups', JSON.generate(lineup)
          expect(last_response.status). to eq(200)
        end

        # it 'is JSON if we set content-type header to application/json' do
        #   post '/expenses', JSON.generate(lineup) do
        #     header['Content-type'] = 'application/json'
        #   end
        #   expect(last_reponse.status).to eq(200)
        # end
      end
    end

    describe 'GET/lineups/:insname' do

      let(:girl_id){ 55 }
      let(:band_id){ 42 }
      let(:instrument){ 'DoubleBass' }
      let(:bandrole){ 'Bassist and backup vocals' }

      context 'when a member has a certain instrument' do
        let(:instrument_on){ [{'some' => 'data' }] }
        before do
          allow(member).to receive(:instrument_on)
          .with(instrument)
          .and_return(instrument_on)
        end

        it 'returns with a instrument in JSON' do
          get "/lineups/#{instrument}"
          expect(last_response.body).to eq( JSON.generate([{'some' => 'data' }]) )
        end

        it 'responds with a 200 (OK)' do
          get "lineups/#{instrument}"
          expect(last_response.status).to eq(200)
        end
      end

      # context 'output data format' do
      #   #need to work out why i can't set a header for this section!!!!
      #   it 'is JSON by default'
      #   it 'is JSON if we set Accept header to applicatiion JSON'
      #   it 'is XML if we set Accept header to text/xml'
      # end

      context 'when there is no lineup with the instrument' do
        let(:instrument_on){ [] }

        before do
          allow(member). to receive(:instrument_on)
          .with(instrument)
          .and_return(instrument_on)
        end

        it 'responds with a 200 (OK)' do
          get "/lineups/#{instrument}"
          expect(last_response.status).to eq(200)
        end

        it 'returns an empty array as JSON' do
          get "/lineups/#{instrument}"
          expect(last_response.body).to eq(JSON.generate([]))
        end
      end
    end
  end
end
