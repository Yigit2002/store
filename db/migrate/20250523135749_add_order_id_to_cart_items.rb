class AddOrderIdToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :cart_items, :order, foreign_key: true, null: true, index: true
  end
end
