class RemoveAddressFieldsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :address, :text
    remove_column :users, :city, :string
    remove_column :users, :country, :string
    remove_column :users, :username, :string
  end
end
