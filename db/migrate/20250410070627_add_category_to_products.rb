class AddCategoryToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :category_id, :integer
    add_foreign_key :products, :categories
  end
end
