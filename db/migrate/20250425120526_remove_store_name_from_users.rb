class RemoveStoreNameFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :store_name, :string
  end
end
