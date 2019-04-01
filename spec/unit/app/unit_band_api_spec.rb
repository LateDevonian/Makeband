require_relative '../../../app/band'
require 'rack/test'
require 'rspec'

module SpiceGirls
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(manage: manage)
    end

    def response
      JSON.parse(last_response.body)
    end
    #imitating Spicegirls class
    let (:manage) { instance_double('SpiceGirls::Manage') }

    describe 'POST /bands' do
      let (:band) { { 'some' => 'data'} }

      context 'when the band is successfully recorded' do
        before do
          allow(manage).to receive(:record)
          .with(band)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the band id' do
          post '/bands', JSON.generate(band)
          expect(response).to include('band_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/bands', JSON.generate(band)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the band fails validation' do
        let(:band) { { "some" => "data" }}
        before do
          allow(manage). to receive(:record)
          .with(band)
          .and_return(RecordResult.new(false, 417, 'band incomplete'))
        end

        it 'returns an error message' do
          post '/bands', JSON.generate(band)
          expect(response).to include('error' => 'band incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/bands', JSON.generate(band)
          expect(last_response.status).to eq(422)
        end
      end

      context 'input data format' do
        before do
          allow(manage). to receive(:record)
          .with(band)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'is JSON by default' do
          post '/bands', JSON.generate(band)
          expect(last_response.status). to eq(200)
        end

        # it 'is JSON if we set content-type header to application/json' do
        #   post '/expenses', JSON.generate(band) do
        #     header['Content-type'] = 'application/json'
        #   end
        #   expect(last_reponse.status).to eq(200)
        # end
      end
    end

    describe 'GET/bands/:bandname' do
      #was :bandname

      let(:bandformed){ '1985-02-27' }
      let(:bandname){ 'A-ha' }
      let(:manager){ 'Rick Berman' }
      let(:gimmick){ 'Assimilation' }
      let(:style){ '80s SynthPop' }
      let(:country_origin){ 'Norway land of elves' }

      context 'when a band is formed on a given date' do

        let(:bandname_on){ [{'some' => 'data' }] }
        before do
          allow(manage).to receive(:bandname_on)
          .with(bandname)
          .and_return(bandname_on)
        end

        it 'returns with a bandname in JSON' do
          get "/bands/#{bandname}"
          expect(last_response.body).to eq( JSON.generate([{'some' => 'data' }]) )
        end

        it 'responds with a 200 (OK)' do
          get "bands/#{bandname}"
          expect(last_response.status).to eq(200)
        end
      end

      context 'output data format' do
        #need to work out why i can't set a header for this section!!!!
        it 'is JSON by default'
        it 'is JSON if we set Accept header to applicatiion JSON'
        it 'is XML if we set Accept header to text/xml'
      end

      context 'when there is no band with the name given' do
        let(:bandname_on){ [] }

        before do
          allow(manage). to receive(:bandname_on)
          .with(bandname)
          .and_return(bandname_on)
        end

        it 'responds with a 200 (OK)' do
          get "/bands/#{bandname}"
          expect(last_response.status).to eq(200)
        end

        it 'returns an empty array as JSON' do
          get "/bands/#{bandname}"
          expect(last_response.body).to eq(JSON.generate([]))
        end
      end
    end
  end
end
