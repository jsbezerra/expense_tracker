module ExpenseTracker

  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  Expense = Struct.new(:expense_id, :payee, :amount, :date)

  class Ledger
    def record(expense)

    end

    def expenses_on(date)

    end
  end
end