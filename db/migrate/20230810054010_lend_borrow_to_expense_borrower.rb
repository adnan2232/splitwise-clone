class LendBorrowToExpenseBorrower < ActiveRecord::Migration[6.1]
  def change

    rename_table :lend_borrows, :expense_borrows
  end
end
