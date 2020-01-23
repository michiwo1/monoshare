class AddCategoryIdToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :category_id, :integer
  end
end