module ExpenseTracker

  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)

    end

    def retrieve(date)

    end
  end
end
