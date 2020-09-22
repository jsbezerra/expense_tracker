require 'expense_tracker/app/api'
require 'expense_tracker/app/ledger'
require 'json'
require 'rack/test'

module ExpenseTracker

  describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    def last_response_body
      JSON.parse(last_response.body)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:expense) { { 'some' => 'data' } }
    let(:successful_record) { RecordResult.new(true, 417, nil) }
    let(:failing_record) { RecordResult.new(false, 417, 'Expense incomplete') }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do

        before do
          allow(ledger).to receive(:record).with(expense).and_return(successful_record)
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          expect(last_response_body).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do

        before do
          allow(ledger).to receive(:record).with(expense).and_return(failing_record)
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(last_response_body).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do

      let(:date) { '2020-09-20' }

      def expenses
        [{:success? => true, :expense_id => 417, :error_message => nil}]
      end

      context 'when expenses exist on the given date' do
        before do
          allow(ledger).to receive(:retrieve).with(date).and_return(expenses)
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2020-09-20'
          expect(last_response_body).to eq([{"error_message"=>nil, "expense_id"=>417, "success?"=>true}])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2020-09-20'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:retrieve).with(date).and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2020-09-20'
          expect(last_response_body).to eq([])
        end
        
        it 'responds with a 200 (OK)' do
          get '/expenses/2020-09-20'
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
