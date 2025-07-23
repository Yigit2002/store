class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :rating, null: false, limit: 1..5

      t.timestamps
    end
  end
end