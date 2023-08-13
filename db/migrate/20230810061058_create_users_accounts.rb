class CreateUsersAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :users_accounts do |t|
      t.references :lender, null: false, foreign_key: {to_table: :users}
      t.references :borrower, null: false, foreign_key: {to_table: :users}
      t.decimal :balance, default: 0, precision: 10, scale: 2

      t.timestamps
    end
  end
end
