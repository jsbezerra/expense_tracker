require 'expense_tracker/app/ledger'
require 'config/sequel'
require_relative '../../support/db'

module ExpenseTracker
  describe Ledger, :aggregate_failures do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
          'payee' => 'Starbucks',
          'amout' => 5.75,
          'date'  => '2020-09-20'
      }
    end

    describe '#record' do
      context 'with a valid expense' do
        it 'successfully saves the expense in the DB' do
          pending
          result = ledger.record(expense)

          expect(result).to be_success
          expect(DB[:expenses].all).to match [a_hash_including(
              id: result.expense_id,
              payee: 'Starbucks',
              amount: 5.75,
              date: Date.iso8601('2020-09-20')
          )]

        end
      end
    end
  end
end