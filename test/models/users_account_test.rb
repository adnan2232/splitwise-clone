require "test_helper"
require_relative "./concerns/dummy_expense"
class UsersAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end 
  include DummyExpense

  test "User account should be effected by expense creation" do
    expense = initialize_valid_dummy_expense
    p expense.save_expense_with_transaction
    u1,u2,u3 = User.take(3)
    
    def checkBalance(user,gt_0)
     
      user.lended.each do |transfer|
        assert gt_0 ? (transfer.balance>0):(transfer.balance==0),"#{user.id} not able to transfer money"
      end
    end
    

    checkBalance(u1,false)
    checkBalance(u2,true)
    checkBalance(u3,false)

  end

  test "Update account must return false on rollback uncomment raise rollback in update_account_with_settle" do
    u1,u2 = User.take(3)
    ua = UsersAccount.new(lender: u1, borrower: u2, balance: 1000 )
    
    assert_not ua.update_account_with_settle || UsersAccount.count>0, "Update account even after Rollback"
  end
end
