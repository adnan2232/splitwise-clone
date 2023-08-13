class CreateTransactionHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_histories do |t|
      t.string :through, default:""
      t.decimal :paid, precision:10,scale:2,null:false
      t.string :notes, default:""
      t.references :lender, null: false, foreign_key: {to_table: :users}
      t.references :borrower, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
