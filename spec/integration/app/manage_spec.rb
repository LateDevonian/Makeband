require_relative '../../../app/manage'

module  SpiceGirls
  RSpec.describe Manage, :aggregate_failures, :db do
    let(:manage) {Manage.new}
    let(:band) do
      {
        'bandname' => 'Spice Girls',
        'manager' => 'Bob Fossil',
        'gimmick' => 'GirlBand',
        'style' => "90s Britpop",
        'country_origin' => 'UK',
        'bandformed' => '1996-05-05'
      }
    end

    def confirm_band(band_key)
      band.delete(band_key)
      result = manage.record(band)
    end

    def deleted_results(band_key, result)
      #goes through all attributes for bands and makes sure they are recorded
      expect(result).not_to be_success
      expect(result.band_id).to eq (nil)
      expect(result.error_message).to include(" '#{band_key}' is required")
      expect(DB[:bands].count).to eq(0)
    end

    describe '#record' do

      context 'with a valid band' do
        it 'successfully saves the band in the DB' do
          result = manage.record(band)

          expect(result).to be_success
          expect(DB[:bands].all).to match [a_hash_including(
            id: result.band_id,
            bandname: 'Spice Girls',
            manager: 'Bob Fossil',
            gimmick: 'GirlBand',
            style: '90s Britpop',
            country_origin: 'UK',
            bandformed: Date.iso8601('1996-05-05')

            )]
        end
      end

      context 'when the band lacks a name' do
        it 'rejects the band as invalid due to no name' do
          band_key = 'bandname'
          result = confirm_band(band_key)
          expect(deleted_results(band_key, result)).to eq(true)
        end
      end

      context 'when the band lacks gimmick' do
        it 'rejects the band as invalid due to no gimmick' do
          band_key = 'gimmick'
          result = confirm_band(band_key)
          expect(deleted_results(band_key, result)).to eq(true)
        end
      end

      context 'when the band lacks a manager' do
        it 'rejects the band as invalid due to no manager' do
          band_key = 'manager'
          result = confirm_band(band_key)
          expect(deleted_results(band_key, result)).to eq(true)
        end
      end

      context 'when the band lacks a style' do
        it 'rejects the band as invalid due to no style' do
          band_key = 'style'
          result = confirm_band(band_key)
          expect(deleted_results(band_key, result)).to eq(true)
        end
      end

      context 'when the band lacks a country of origin' do
        it 'rejects the band as invalid due to no country_origin' do
          band_key = 'country_origin'
          result = confirm_band(band_key)
          expect(deleted_results(band_key, result)).to eq(true)
        end
      end

      context 'when the band lacks a date formed' do
        it 'rejects the band as invalid due to no bandformed' do
          band_key = 'bandformed'
          result = confirm_band(band_key)
          expect(deleted_results(band_key, result)).to eq(true)
        end
      end


    end

    describe '#country_origin' do
      it 'returns all bands for the provided country of origin ' do
        result_1 = manage.record(band.merge('country_origin' => 'UK'))
        result_2 = manage.record(band.merge('country_origin' => 'UK'))
        result_3 = manage.record(band.merge('country_origin' => 'AUS'))

        expect(manage.country_origin_on('UK')).to contain_exactly(
          a_hash_including(id: result_1.band_id),
          a_hash_including(id: result_2.band_id)
        )
      end

      it 'returns a blank array when there are no matching bands' do
        expect(manage.country_origin_on('US')).to eq([])
      end
    end
  end
end
