require "test_helper"
require_relative "./concerns/dummy_expense"

class ExpenseTest < ActiveSupport::TestCase
  include DummyExpense
  # test "the truth" do
  #   assert true
  # end

  test "check if nested borrowers working and should save because amount equals" do
    expense = initialize_valid_dummy_expense

    assert expense.save_expense_with_transaction , "Could not save valid expense"
  end

  test "check if nested borrowers working and shouldn't save because amount not equals" do
    expense = initialize_invalid_dummy_expense

    assert_not expense.save_expense_with_transaction, "Saved invalid expense"
  end

end
