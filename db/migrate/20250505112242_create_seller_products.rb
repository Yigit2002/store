class CreateSellerProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :seller_products do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      
      t.decimal :price, precision: 10, scale: 2 # Örnek: Fiyat için
      t.integer :stock # Örnek: Stok miktarı için

      t.timestamps
    end
  end
end
