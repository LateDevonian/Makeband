require_relative '../../../app/lineup'

module Lineup

  RSpec.describe Member, :aggregate_failures, :db do
    let(:member) {Member.new}
    let(:lineup) do
      {
        'girl_id' => 123,
        'band_id' => 456,
        'bandrole' => 'Lead Singer',
        'instrument' => 'Voice and bass'
      }
    end

    def confirm_lineup(lineup_key)
      lineup.delete(lineup_key)
      result = member.record(lineup)
    end

    def deleted_results(lineup_key, result)
      #goes through all attributes for lineup and makes sure they are recorded
      expect(result).not_to be_success
      expect(result.lineup_id).to eq (nil)
      expect(result.error_message).to include(" '#{lineup_key}' is required")
      expect(DB[:lineups].count).to eq(0)
    end

    describe '#record' do

      context 'with a valid lineup' do
        it 'successfully saves the lineup in the DB' do
          result = member.record(lineup)

          expect(result).to be_success
          expect(DB[:lineups].all).to match [a_hash_including(
            id: result.lineup_id,
            girl_id: 123,
            band_id: 456,
            bandrole: 'Lead Singer',
            instrument: 'Voice and bass'
            )]
        end
      end

      context 'when the lineup lacks a band' do
        it 'rejects the lineup as invalid due to no band' do
          lineup_key = 'band_id'
          result = confirm_lineup(lineup_key)
          expect(deleted_results(lineup_key, result)).to eq(true)
        end
      end

      context 'when the lineup lacks members' do
        it 'rejects the lineup as invalid due to no member' do
          lineup_key = 'girl_id'
          result = confirm_lineup(lineup_key)
          expect(deleted_results(lineup_key, result)).to eq(true)
        end
      end

      context 'when the lineup lacks a bandrole' do
        it 'rejects the lineup as invalid due to no one doing anything in it' do
          lineup_key = 'bandrole'
          result = confirm_lineup(lineup_key)
          expect(deleted_results(lineup_key, result)).to eq(true)
        end
      end

      context 'when the lineup lacks an instrument' do
        it 'rejects the lineup as invalid due to no one playing anything' do
          lineup_key = 'instrument'
          result = confirm_lineup(lineup_key)
          expect(deleted_results(lineup_key, result)).to eq(true)
        end
      end
    end

    describe '#lineup member' do
      it 'returns all lineup for the provided instrument ' do
        result_1 = member.record(lineup.merge('instrument' => 'guitar'))
        result_2 = member.record(lineup.merge('instrument' => 'guitar'))
        result_3 = member.record(lineup.merge('instrument' => 'keytar'))

        expect(member.instrument_on('guitar')).to contain_exactly(
          a_hash_including(id: result_1.lineup_id),
          a_hash_including(id: result_2.lineup_id)
        )
      end

      it 'returns a blank array when there are no matching instruments' do
        expect(member.instrument_on('triangle')).to eq([])
      end
    end
  end
end
