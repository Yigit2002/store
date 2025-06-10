class RemoveSellerProductIdFromOrder < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :seller_product_id
  end
end
