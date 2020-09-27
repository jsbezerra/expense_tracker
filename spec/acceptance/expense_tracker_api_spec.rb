require 'rack/test'
require 'json'

require 'config/sequel'
require 'expense_tracker/app/api'
require 'expense_tracker/app/ledger'
require 'support/api_helpers'

module ExpenseTracker

  describe 'Expense Tracker API', :db do
    include Rack::Test::Methods

    include APIHelpers

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('id' => a_kind_of(Integer))
      expense.merge('id' => parsed['id'])
    end

    it 'records submitted expenses' do
      coffee = post_expense('payee' => 'Starbucks', 'amount' => 5.75, 'date' => '2020-09-20')

      zoo = post_expense('payee' => 'Zoo', 'amount' => 15.25, 'date' => '2020-09-20')

      post_expense('payee' => 'Whole Foods', 'amount' => 95.20, 'date' => '2020-09-21')

      get '/expenses/2020-09-20'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end
