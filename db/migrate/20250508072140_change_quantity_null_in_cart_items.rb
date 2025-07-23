class ChangeQuantityNullInCartItems < ActiveRecord::Migration[8.0]
  def change
    change_column_null :cart_items, :quantity, true
  end
end