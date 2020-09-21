require 'rack/test'
require 'json'

module ExpenseTracker

  describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    it 'records submitted expenses' do
      pending 'POST not implemented yet'
      coffee = {
          'payee' => 'Starbucks',
          'amount' => 5.75,
          'data' => '2020-09-20'
      }

      post '/expenses', JSON.generate(coffee)
    end
  end
end
