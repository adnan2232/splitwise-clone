class Expense < ApplicationRecord
  #Expense is a special type of transaction i.e. It is a group transaction
  #It effects multiple user accounts and it creates transaction histories
  #between lender and borrowers

  belongs_to :creator, class_name: 'User', foreign_key: :created_by_id
  belongs_to :incurred_by, class_name: 'User', foreign_key: :incurred_by_id
  has_many :borrowers, class_name: 'ExpenseBorrow', foreign_key: :expense_id, inverse_of: :expense
  #Borrowers are people, that owes money to person incurred the cost
  #person incurred the cost can also be a borrower, that means they also
  #have share in expense
  
  accepts_nested_attributes_for :borrowers, allow_destroy: true
  validates :borrowers, length: {minimum: 1, message: 'Should have at least one borrower'}
  
  validate :unique_borrowers?,:amounts_not_lte_zero?,:sum_equal?
  before_validation :preprocess_borrowers


  def save_expense_with_transaction
    #Expense save effects expense_borrow, UserAccounts and Transaction History
    #If any fails all transaction will be roll back and expense creation fails
    transaction_success = true

    Expense.transaction do
      begin

        self.save!
        borrowers.each do|borr|
          ua = UsersAccount.new(lender:borr.lender,borrower:borr.borrower,balance:borr.amount)
          ua.update_account_with_expense({:notes=>description})
        end

      rescue => e
        errors.add(:base,"Something went wrong") if errors.empty?
        transaction_success = false
        raise ActiveRecord::Rollback
      end

    end
    
    return transaction_success
  end

  private 
  
  def sum_equal?
    #Check if amount divided among friends equal to expense amount
    div_sum = borrowers.map(&:amount).sum
    if !((amount-0.01)<=div_sum && div_sum<=(amount+0.01))
      errors.add(:base,"Total amount should be equal to sum of divided amount among friends")
      false
    end

  end

  def unique_borrowers?
    #Check if all borrowers are unique
    borrower_ids = borrowers.map(&:borrower_id)
 
    if borrower_ids.uniq.size != borrower_ids.size
      errors.add(:base,"Owers mustn't repeat")
      false
    end
  end

  def amounts_not_lte_zero?
    #Check if total amount or divided amount is less than equal to zero

    if amount<=0 || borrowers.reduce(false){|acc,curr| acc||(curr.amount<=0)}
      errors.add(:base,"Amount cannot be less than equal to zero")
    end
  end

  def preprocess_borrowers
    #setting lender of each borrower to incurred by

    borrowers.each do |borrower|
      borrower.lender_id = incurred_by_id
    end

  end

end
