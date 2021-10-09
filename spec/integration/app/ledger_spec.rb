# frozen_string_literal: true

require "expense_tracker/app/ledger"
require "config/sequel"

module ExpenseTracker
  describe Ledger, :db do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        "payee" => "Starbucks",
        "amount" => 5.75,
        "date" => "2020-09-20"
      }
    end

    describe "#record" do
      context "with a valid expense" do
        it "successfully saves the expense in the DB" do
          result = ledger.record(expense)

          expect(result).to be_success
          expect(DB[:expenses].all).to match [a_hash_including(
            id: result.id,
            payee: "Starbucks",
            amount: 5.75,
            date: Date.iso8601("2020-09-20")
          )]
        end
      end

      context "when the expense lacks a payee" do
        it "rejects the expense as invalid" do
          expense.delete("payee")

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.id).to be_nil
          expect(result.error_message).to include("`payee` is required")

          expect(DB[:expenses].count).to eq(0)
        end
      end

      context "when the expense lacks an amount" do
        it "rejects the expense as invalid" do
          expense.delete("amount")

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.id).to be_nil
          expect(result.error_message).to include("`amount` is required")

          expect(DB[:expenses].count).to eq(0)
        end
      end

      context "when the expense lacks a date" do
        it "rejects the expense as invalid" do
          expense.delete("date")

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.id).to be_nil
          expect(result.error_message).to include("`date` is required")

          expect(DB[:expenses].count).to eq(0)
        end
      end

      context "when the expense lacks an amount and a date" do
        it "rejects the expense as invalid" do
          expense.delete("amount")
          expense.delete("date")

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.id).to be_nil
          expect(result.error_message).to include("`amount, date` are required")

          expect(DB[:expenses].count).to eq(0)
        end
      end

      context "when the expense has an id" do
        it "rejects the expense as invalid" do
          expense["id"] = 1

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.id).to be_nil
          expect(result.error_message).to include("new record can not have id")

          expect(DB[:expenses].count).to eq(0)
        end
      end
    end

    describe "#expenses_on" do
      it "returns all expenses for the provided date" do
        result1 = ledger.record(expense.merge("date" => "2020-09-20"))
        result2 = ledger.record(expense.merge("date" => "2020-09-20"))
        ledger.record(expense.merge("date" => "2020-09-21"))

        expect(ledger.expenses_on("2020-09-20")).to contain_exactly(
          a_hash_including(id: result1.id),
          a_hash_including(id: result2.id)
        )
      end

      it "returns a blank array when there are no matching expenses" do
        expect(ledger.expenses_on("2020-09-20")).to eq([])
      end
    end
  end
end
