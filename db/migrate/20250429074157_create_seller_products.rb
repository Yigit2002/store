class CreateSellerProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :seller_products do |t|
      t.references :seller, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
