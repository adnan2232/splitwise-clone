class ExpenseBorrow < ApplicationRecord
  belongs_to :expense, class_name:"Expense"
  belongs_to :lender, class_name:"User"
  #Lender is optional field same information can also fetched through incurred by in expenses 
  belongs_to :borrower, class_name:"User"
end
