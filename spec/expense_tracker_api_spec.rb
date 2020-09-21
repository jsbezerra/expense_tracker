require 'rack/test'
require 'json'
require 'expense_tracker/app/api'

module ExpenseTracker

  describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    it 'records submitted expenses' do
      coffee = {
          'payee' => 'Starbucks',
          'amount' => 5.75,
          'data' => '2020-09-20'
      }

      post '/expenses', JSON.generate(coffee)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
    end
  end
end
