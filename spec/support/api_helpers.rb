# frozen_string_literal: true

require "expense_tracker/app/api"

shared_context "APIHelpers" do
  include Rack::Test::Methods

  def app
    ExpenseTracker::API.new
  end
end
