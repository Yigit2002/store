class AddSellerIdToCartItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :cart_items, :seller, foreign_key: { to_table: :users }, null: true
  end
end