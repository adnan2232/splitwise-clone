class ExpDateTextToDate < ActiveRecord::Migration[6.1]
  def change
    change_column :expenses, :exp_date, 'date USING CAST(exp_date AS date)', null:false,default: ->{'CURRENT_DATE'}
  end
end
