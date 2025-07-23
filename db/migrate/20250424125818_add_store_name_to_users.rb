class AddStoreNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :store_name, :string
  end
end
