class ChangeEmailAndPhoneInUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :email_address, :email
    rename_column :users, :telefon_numarasi, :gsm
  end
end
