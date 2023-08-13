class ExpenseController < ApplicationController
    include ApplicationHelper
    def new 
        @expense = Expense.new 
        render partial: 'expense/expense_form',locals:{expense:@expense}
    end

    def create
        expense = Expense.new(expense_params)
        
        if expense.save_expense_with_transaction
            flash[:notice] = "Expense created successfully"
        else
            flash[:alert] = acc_error_message(expense.errors)
            p flash[:alert]
        end
        redirect_to :controller=>:static,:action=>:dashboard

    end


    private
    def expense_params
        params[:expense][:created_by_id] = current_user.id
        params.require(:expense).permit(
            :created_by_id,:description,:amount,:incurred_by_id,:exp_date,
            borrowers_attributes: [:borrower_id,:amount,:_destroy]
        )
    end

end