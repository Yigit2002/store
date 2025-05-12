class RemoveSellerIdsFromProducts < ActiveRecord::Migration[8.0]
  def change
      remove_column :products, :seller_ids
  end
end
