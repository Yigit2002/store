class AddSellerIdToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :seller_ids, :integer
    add_index :products, :seller_ids
    add_foreign_key :products, :users, column: :seller_ids
  end
end
