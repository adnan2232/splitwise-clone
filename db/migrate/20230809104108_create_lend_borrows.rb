class CreateLendBorrows < ActiveRecord::Migration[6.1]
  def change
    create_table :lend_borrows do |t|
      t.references :expense, null: false, foreign_key: {to_table: :expenses}
      t.references :lender, null: false, foreign_key: {to_table: :users}
      t.references :borrower, null: false, foreign_key: {to_table: :users}
      t.decimal :amount, precision: 10, scale:2
      t.timestamps
    end
  end
end
