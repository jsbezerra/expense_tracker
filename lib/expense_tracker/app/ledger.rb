require 'config/sequel'

module ExpenseTracker

  RecordResult = Struct.new(:success?, :id, :error_message)
  Expense      = Struct.new(:id, :payee, :amount, :date)

  class Ledger

    REQUIRED_EXPENSE_FIELDS = %w[amount date payee]

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
      if expense.key? 'id'
        RecordResult.new(false, nil, 'Invalid expense: new record can not have id')
      end
    end

    def validate_missing_fields(expense)
      missing_fields = []
      REQUIRED_EXPENSE_FIELDS.each do |field|
        unless expense.key? field
          missing_fields << field
        end
      end

      unless missing_fields.empty?
        message = create_missing_fields_message(missing_fields)
        RecordResult.new(false, nil, message)
      end
    end

    def create_missing_fields_message(fields)
      if fields.size == 1
        "Invalid expense: `#{fields[0]}` is required"
      else
        "Invalid expense: `#{fields.join(', ')}` are required"
      end
    end
  end
end
