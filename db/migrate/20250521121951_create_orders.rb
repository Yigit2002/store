class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :seller_product, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
