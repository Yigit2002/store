class AddDefaultStatusToOrders < ActiveRecord::Migration[8.0]
  def up
    change_column_default :orders, :status, 0
  end

  def down
    change_column_default :orders, :status, nil
  end
end