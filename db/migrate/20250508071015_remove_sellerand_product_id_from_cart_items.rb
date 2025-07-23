class RemoveSellerandProductIdFromCartItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :cart_items, :product_id
    remove_column :cart_items, :seller_id
  end
end
