class UsersAccount < ApplicationRecord
  #UsersAccount is a two way money transfer account
  #It is created between 2 users

  belongs_to :lender, class_name: "User", foreign_key: :lender_id
  belongs_to :borrower, class_name: "User", foreign_key: :borrower_id
 

  #1 (a,b) represents a is lender and b is borrower and 
  #2 balance[(a,b)] represents amount b owe to a 
  #3 balance[(a,b)] >0 if and only if balance[(b,a)] =0 and vice versa
  #4 balance[(a,b)]=balance[(b,a)]=0 both can be zero at the same time
  #5 It is two way account and #2 ensures data consistency 

  def update_account_with_expense(options={})
    # raise ActiveRecord::Rollback, #uncomment this line for testing if rollback is working or not

    #transfering transaction money
    options[:through] = "expense"
    self.update_account(options)
  end 

  def update_account_with_settle(options={})
    success = true
   
    UsersAccount.transaction do 
      # raise ActiveRecord::Rollback, #uncomment this line for testing if rollback is working or not
      begin
        if (balance_gt_owe? || balance_lte_zero?)
          errors.add(:base,"Invalid amount passed")
          raise  ActiveRecord::RecordInvalid.new(self) 
        end
        options[:through] = "settle"
        self.update_account(options)
      rescue => e
        errors.add(:base,"Something went wrong") if errors.empty?
        success = false
        raise ActiveRecord::Rollback
      end
    end
   

    return success
  end

  private
  def update_account(options={})

    #Create Transaction history
    th = TransactionHistory.new(
      :lender=>self.lender,:borrower=>self.borrower,
      :paid=>self.balance,:notes=>options[:notes]||"No notes",
      :through=>options[:through]||"direct"
    )
    th.save!

    #No cyclic account needs to be created or maintain
    if self.lender==self.borrower
      return true
    end 

    #Check if bidirectional account exist if not create one
    l_to_b =  UsersAccount.find_or_create_by(:lender=>self.lender, :borrower=>self.borrower)  
    b_to_l= UsersAccount.find_or_create_by(:lender=>self.borrower,:borrower=>self.lender)

    
    #Begin Money transfer 
    #One Account will always remain zero
    if self.balance > b_to_l.balance
      l_to_b.update(:balance=>l_to_b.balance+self.balance-b_to_l.balance)
      b_to_l.update(:balance=>0)
    else
      b_to_l.update(:balance=>b_to_l.balance-self.balance)
    end 
  end


  def balance_gt_owe?
    balance > UsersAccount.find_by(lender_id: borrower_id, borrower_id: lender_id).balance
  end

  def balance_lte_zero?
    balance<=0
  end
end
