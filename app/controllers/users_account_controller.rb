class UsersAccountController < ApplicationController
    include ApplicationHelper
    def index
        @owes = current_user.borrowed.where('balance>0').order(:updated_at=>:DESC)
    end

    def update_users_account
        p params
        transfer = UsersAccount.new(
            lender: current_user,
            borrower: User.find(params[:borrower_id]),
            balance: params[:balance]
        )

        if transfer.update_account_with_settle({:notes=>params[:notes]})
            flash[:notice] = "Amount transfer successfully"
        else
            
            flash[:alert] = acc_error_message(transfer.errors)
        end
        
        redirect_to action: :index
    end

end