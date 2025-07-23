class AddSellerProductIdToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_column :cart_items, :seller_product_id, :integer
    add_index :cart_items, :seller_product_id
    add_foreign_key :cart_items, :seller_products
  end
end
