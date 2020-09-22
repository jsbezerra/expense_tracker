require 'sinatra/base'
require 'json'

module ExpenseTracker
  class API < Sinatra::Base

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result  = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      results = @ledger.expenses_on(params[:date]).inject([]) do |arr, result|
        arr << { :expense_id => result.expense_id,
                 :payee      => result.payee,
                 :amount     => result.amount,
                 :date       => result.date }
      end
      JSON.generate(results)
    end
  end
end
