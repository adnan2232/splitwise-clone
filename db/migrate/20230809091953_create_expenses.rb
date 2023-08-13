class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :created_by, null: false, foreign_key: {to_table: :users}
      t.references :incurred_by, null: false, foreign_key: {to_table: :users}
      t.date :exp_date, null:false
      t.text :description, null:false
      t.float :amount, null:false

      t.timestamps
    end
  end
end
