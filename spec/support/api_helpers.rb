require 'expense_tracker/app/api'

module APIHelpers
  include Rack::Test::Methods

  def app
    ExpenseTracker::API.new
  end
end