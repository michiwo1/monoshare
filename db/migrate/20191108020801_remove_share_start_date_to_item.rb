class RemoveShareStartDateToItem < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :share_start_date, :integer
    remove_column :items, :share_end_date, :integer
  end
end
