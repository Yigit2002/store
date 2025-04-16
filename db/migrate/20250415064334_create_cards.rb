class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :number
      t.string :security_code
      t.date :expiry_date
      t.decimal :balance

      t.timestamps
    end
  end
end
