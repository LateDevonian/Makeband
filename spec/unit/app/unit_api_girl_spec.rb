require_relative '../../../app/girl'
require 'rack/test'
require 'rspec'

module Bandmember
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(person: person)
    end

    def response
      JSON.parse(last_response.body)
    end

    let (:person) { instance_double('bandmember::person') }

    describe 'POST /girls' do
      let (:girl) { { 'some' => 'data'} }

      context 'when the girl is successfully recorded' do
        before do
          allow(person).to receive(:record)
          .with(girl)
          .and_return(RecordResult.new(true, 417, nil))
         end

        it 'returns the girl id' do
          post '/girls', JSON.generate(girl)
          expect(response).to include('girl_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/girls', JSON.generate(girl)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the girl fails validation' do
        let(:girl) { { "some" => "data" }}
        before do
          allow(person). to receive(:record)
          .with(girl)
          .and_return(RecordResult.new(false, 417, 'girl incomplete'))
        end

        it 'returns an error message' do
          post '/girls', JSON.generate(girl)
          expect(response).to include('error' => 'girl incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/girls', JSON.generate(girl)
          expect(last_response.status).to eq(422)
        end
      end

      context 'input data format' do
        before do
          allow(person). to receive(:record)
          .with(girl)
          .and_return(RecordResult.new(true, 417, nil))
        end

        it 'is JSON by default' do
          post '/girls', JSON.generate(girl)
          expect(last_response.status). to eq(200)
        end
      end
    end

    describe 'GET/girls/:nickname' do

      let(:dob){ '1945-02-27' }
      let(:firstname){ 'Annie' }
      let(:surnane){ 'Lennox' }
      let(:quirk){ 'Stunning voice' }
      let(:nickname){ 'Big-A' }

      context 'when a person has a certain nickname' do
        let(:nickname_on){ [{'some' => 'data' }] }
        before do
          allow(person).to receive(:nickname_on)
          .with(nickname)
          .and_return(nickname_on)
        end

        it 'returns with a nickname in JSON' do
          get "/girls/#{nickname}"
          expect(last_response.body).to eq( JSON.generate([{'some' => 'data' }]) )
        end

        it 'responds with a 200 (OK)' do
          get "girls/#{nickname}"
          expect(last_response.status).to eq(200)
        end
      end
      #write more tests when figured out multiple routes in sinatra

      # context 'output data format' do
      # #failing miserably is the way to go
      #   it 'is JSON by default'
      #   it 'is JSON if we set Accept header to applicatiion JSON'
      #   it 'is XML if we set Accept header to text/xml'
      # end

      context 'when there is no girl with the nickname given' do
        let(:nickname_on){ [] }

        before do
          allow(person). to receive(:nickname_on)
          .with(nickname)
          .and_return(nickname_on)
        end

        it 'responds with a 200 (OK)' do
          get "/girls/#{nickname}"
          expect(last_response.status).to eq(200)
        end

        it 'returns an empty array as JSON' do
          get "/girls/#{nickname}"
          expect(last_response.body).to eq(JSON.generate([]))
        end
      end
    end

    describe 'PUT/girls/edit/:id' do

      let (:girl) { instance_double('bandmember::api') }
      let (:update_girl) { { 'some' => 'data'} }
      let (:girl_key) { 'surname' }
      let (:girl_id) { 666 }
      let (:new_key_value) { 'Bourne' }

      before do
        allow(person).to receive(:update_girl)
        .with(girl_key, girl_id, new_key_value)
        .and_return(RecordResult.new(true, 666, nil) )
      end

      context 'the person is updated' do


        it 'updates the surname as requested'
        #Work on this functionality next!!! not working in app

        #   put "/girls/edit" , JSON.generate(girl)
        #   result = person.update_girl(girl_key, girl_id, new_key_value), JSON.generate(girl_key, girl_id, new_key_value)
        #   expect(response).to include('girl_id' => 666 )
        # end

        it 'updates the first name as requested'
        it 'updates the nickname as requested'
        it 'updates the quirk as requested'
        it 'updates the dob as requested'
      end

      context 'the girl does not exist' do
        it 'does not find the person to update'
        it 'cannot update the attribute supplied'
      end
    end
  end
end
