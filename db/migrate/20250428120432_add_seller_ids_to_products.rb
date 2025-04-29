class AddSellerIdsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :seller_ids, :integer
  end
end
