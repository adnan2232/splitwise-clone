class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :created_expenses, class_name:"Expense", foreign_key: :created_by_id
  has_many :incurred_expenses, class_name:"Expense", foreign_key: :incurred_by_id
  #User incurred expenses (Expenses for which user paid)
  has_many :lended, class_name: "UsersAccount", foreign_key: :lender_id
  #lended: Person owes money to user account
  has_many :borrowed, class_name: "UsersAccount", foreign_key: :borrower_id
  #borrowes: User owes money to person account
  has_many :transactions, class_name: "TransactionHistory", foreign_key: :lender_id
  has_many :reverse_transactions,  class_name: "TransactionHistory", foreign_key: :borrower_id
  #User all transactions history (Expense and settle transactions history )

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def total_balance
    self.total_due-self.total_owe
  end

  def total_owe
    borrowed.sum(:balance)
  end

  def total_due
    lended.sum(:balance)
  end

  def get_friends
    #Get all user accounts except current_user
    User.where.not(:id=>self.id)
  end

  def get_expenses_of_user(user_id)
    #query to fetch  history for user id
    #it first shows current_user expense with friend
    #then sort other users with date

    query = <<-SQL
    SELECT * FROM (
      SELECT e.description AS "description",
      e.amount AS "paid", e.exp_date AS "expense_date",
      eb.amount AS "lended", 'EXP' AS through,
      lender.id AS "lender_id", lender.email AS "lender_email",
      borrower.id AS "borrower_id", borrower.email AS "borrower_email"
      FROM expenses e, expense_borrows eb,users lender, users borrower
      WHERE e.id=eb.expense_id
      AND ((eb.lender_id=?) OR (eb.borrower_id=?))
      AND lender.id=eb.lender_id AND borrower.id=eb.borrower_id
      AND lender.id<>borrower.id

      UNION ALL

      SELECT th.notes AS "description",
      th.paid AS "paid", th.created_at AS "expense_date",
      0 AS "lended", 'SETT' AS through,
      lender.id AS "lender_id", lender.email AS "lender_email",
      borrower.id AS "borrower_id", borrower.email AS "borrower_email"
      FROM transaction_histories th, users lender, users borrower
      WHERE ((th.lender_id=?) OR (th.borrower_id=?))
      AND lender.id=th.lender_id AND borrower.id=th.borrower_id
      AND lender.id<>borrower.id AND th.through='settle'
    ) t
    ORDER BY (lender_id=? OR borrower_id=?) DESC, expense_date DESC
    SQL

    san_query = ApplicationRecord.sanitize_sql([query,user_id,user_id,user_id,user_id,self.id,self.id])
    ActiveRecord::Base.connection.exec_query(san_query)
  end


end
