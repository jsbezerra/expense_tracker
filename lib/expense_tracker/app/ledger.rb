# frozen_string_literal: true

require "config/sequel"

module ExpenseTracker
  RecordResult = Struct.new(:success?, :id, :error_message)
  Expense      = Struct.new(:id, :payee, :amount, :date)

  # Implements the communication with the database.
  class Ledger
    REQUIRED_EXPENSE_FIELDS = %w[amount date payee].freeze

    def record(expense)
      missing = validate_missing_fields(expense)
      return missing unless missing.nil?

      id_error = validate_id(expense)
      return id_error unless id_error.nil?

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end

    private

    def validate_id(expense)
      RecordResult.new(false, nil, "Invalid expense: new record can not have id") if expense.key? "id"
    end

    def validate_missing_fields(expense)
      missing_fields = []
      REQUIRED_EXPENSE_FIELDS.each do |field|
        missing_fields << field unless expense.key? field
      end

      RecordResult.new(false, nil, create_missing_fields_message(missing_fields)) unless missing_fields.empty?
    end

    def create_missing_fields_message(fields)
      if fields.size == 1
        "Invalid expense: `#{fields[0]}` is required"
      else
        "Invalid expense: `#{fields.join(", ")}` are required"
      end
    end
  end
end
