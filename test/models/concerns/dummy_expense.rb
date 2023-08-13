module DummyExpense

    def initialize_valid_dummy_expense
       
        user1,user2,user3 = User.take(3)
        expense = Expense.new(
        creator:user1, incurred_by:user2,
        amount:1000,exp_date:Date.current
        )

        borrowers = expense.borrowers.build(
        [
            {borrower:user1,amount:550},
            {borrower:user3,amount:400},
            {borrower:user2,amount:50}
        ]
        )

        expense

    end

    def initialize_invalid_dummy_expense
        user1,user2,user3 = User.take(3)
        expense = Expense.new(
        creator:user1, incurred_by:user2,
        amount:1000,exp_date:Date.current
        )

        borrowers = expense.borrowers.build(
        [
            {borrower:user1,amount:550},
            {borrower:user3,amount:230}
        ]
        )
     
        expense

    end
end