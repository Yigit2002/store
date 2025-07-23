class AddTelefonNumarasiToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :telefon_numarasi, :string
  end
end
