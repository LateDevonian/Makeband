require_relative '../../../app/person'

module  Bandmember
  RSpec.describe Person, :aggregate_failures, :db do
    let(:person) {Person.new}
    let(:girl) do
      {
        'firstname' => 'Melanie',
        'surname' => 'Brown',
        'nickname' => 'Scary',
        'quirk' => 'Catsuit',
        'dob' => '1996-04-04'
      }
    end

    def confirm_girl(girl_key)
      girl.delete(girl_key)
      person.record(girl)
    end

    def get_girl(girl_key)
      person.return_girl(girl_id)
    end

    def update_girl(girl_key, girl_id, new_key_value)
      person.update_girl(girl_key, girl_id, new_key_value)
    end

    def deleted_results(girl_key, result)
      #goes through all attributes for bands and makes sure they are recorded
      expect(result).not_to be_success
      expect(result.girl_id).to eq (nil)
      expect(result.error_message).to include(" '#{girl_key}' is required")
      expect(DB[:girls].count).to eq(0)
    end


    describe '#record' do

      context 'with a valid member' do
        it 'successfully saves the person in the DB' do

          result = person.record(girl)

          expect(result).to be_success

          expect(DB[:girls].all).to match [a_hash_including(
            id: result.girl_id,
            firstname: 'Melanie',
            surname: 'Brown',
            nickname: 'Scary',
            quirk:  'Catsuit',
            dob: Date.iso8601('1996-04-04')
          )]
        end
      end

      context "when the member lacks a firstname" do
        it 'rejects the member as invalid due to no name' do
          girl_key = 'firstname'
          result = confirm_girl(girl_key)
          expect(deleted_results(girl_key, result)).to eq(true)
        end
      end

      context "when the girl lacks surname" do
        it 'rejects the girl as invalid due to no surname' do
          girl_key = 'surname'
          result = confirm_girl(girl_key)
          expect(deleted_results(girl_key, result)).to eq(true)
        end
      end

      context 'when the girl lacks a nickname' do
        it 'rejects the girl as invalid due to no nickname' do
          girl_key = 'nickname'
          result = confirm_girl(girl_key)
          expect(deleted_results(girl_key, result)).to eq(true)
        end
      end

      context 'when the girl lacks a quirk' do
        it 'rejects the girl as invalid due to no quirk' do
          girl_key = 'quirk'
          result = confirm_girl(girl_key)
          expect(deleted_results(girl_key, result)).to eq(true)
        end
      end

      context 'when the girl lacks a date joined' do
        it 'rejects the girl as invalid due to no join date' do
          girl_key = 'dob'
          result = confirm_girl(girl_key)
          expect(deleted_results(girl_key, result)).to eq(true)
        end
      end
    end

    describe '#quirk' do
      it 'returns all girls for the provided quirk ' do
        result_1 =  person.record(girl.merge('quirk' => 'Singing'))
        result_2 =  person.record(girl.merge('quirk' => 'Singing'))
        result_3 =  person.record(girl.merge('quirk' => 'Furry'))

        expect( person.quirk_on('Singing')).to contain_exactly(
          a_hash_including(id: result_1.girl_id),
          a_hash_including(id: result_2.girl_id)
        )
      end

      it 'returns a blank array when there are no matching girls' do
        expect( person.quirk_on('One Leg')).to eq([])
      end
    end

    describe '#return return a person' do
        it 'returns all the details of a member' do
          result = person.record(girl)
          girl_id = result[:girl_id]
          result_2 = person.return_girl(girl_id)

        expect(result_2).to match [a_hash_including(
          id: result.girl_id,
          firstname: 'Melanie',
          surname: 'Brown',
          nickname: 'Scary',
          quirk:  'Catsuit'
        )]
      end

      it 'returns an error when person invalid' do
        result =  person.record(girl)
        girl_id = result[:girl_id]
        result_2 = person.return_girl(girl_id)

        expect(result_2).to_not match [a_hash_including(
          firstname: 'Bobby',
          surname: 'Brown'
        )]
      end
    end

    describe '#update girl' do
      context 'it updates atttributes and saves them' do

        let(:result) {person.record(girl)}
        let(:girl_id) { result[:girl_id] }


        it 'updates a firstname' do

          girl_key = "firstname"
          new_key_value = 'Mercedes'
          update_girl(girl_key, girl_id, new_key_value)
          result_2 = person.return_girl(girl_id)

          expect(result_2).to match [a_hash_including(
            id: result.girl_id,
            firstname: 'Mercedes'
          )]
        end

        it 'updates a quirk' do
          girl_key = "quirk"
          new_key_value = 'On-stage disembowellment'
          update_girl(girl_key, girl_id, new_key_value)
          result_2 = person.return_girl(girl_id)

          expect(result_2).to match [a_hash_including(
            id: result.girl_id,
            quirk: 'On-stage disembowellment'
          )]
        end

        it 'updates a nickname' do
          girl_key = "nickname"
          new_key_value = 'Lumpyspice'
          update_girl(girl_key, girl_id, new_key_value)
          result_2 = person.return_girl(girl_id)

          expect(result_2).to match [a_hash_including(
            id: result.girl_id,
            nickname: 'Lumpyspice'
          )]
        end

        it 'updates a surname' do
          girl_key = "surname"
          new_key_value = 'Jones'
          update_girl(girl_key, girl_id, new_key_value)
          result_2 = person.return_girl(girl_id)

          expect(result_2).to match [a_hash_including(
            id: result.girl_id,
            firstname: 'Melanie',
            surname: 'Jones'
          )]
        end
      end

      context 'when invalid data' do
        let(:result) { person.record(girl) }
        let(:girl_id) { result[:girl_id] }

        context 'when the item to be updated does not exist' do
          it 'fails gracefully' do
           result_2 = update_girl("blah", girl_id, "Whatevs")
           expect(result_2).to include( "Invalid item: 'blah' is invalid " )
          end
        end

        context 'when there are no matching girls' do
          it 'returns a blank array' do
            girl_id = 888
            result_3 = person.update_girl("surname", girl_id, "Diaz")
            expect(result_3).to include( "Invalid item: person is invalid" )
          end
        end
      end
    end
  end
end
