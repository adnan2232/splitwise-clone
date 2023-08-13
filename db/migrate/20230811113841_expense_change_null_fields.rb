class ExpenseChangeNullFields < ActiveRecord::Migration[6.1]
  def change
    change_column :expenses, :amount, :decimal,:precision=>10,:scale=>2, null: false
    change_column :expenses, :description, :text, default: "", null: false
    change_column :expenses, :exp_date, :text ,null:false
    change_column :expense_borrows, :amount, :decimal,:precision=>10,:scale=>2, null: false
  end
end
