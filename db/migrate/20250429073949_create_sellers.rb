class CreateSellers < ActiveRecord::Migration[8.0]
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :sellers, :email_address, unique: true
  end
end
