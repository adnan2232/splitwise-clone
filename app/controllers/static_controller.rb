class StaticController < ApplicationController
  before_action :set_objects

  def dashboard
  end

  def person
  end

  private
  def set_objects
    user_id = params[:id] || current_user.id
    @user = User.find(user_id)
    @expenses = current_user.get_expenses_of_user(user_id)
    @friends = current_user.get_friends
  end


end
