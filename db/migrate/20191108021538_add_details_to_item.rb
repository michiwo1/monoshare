class AddDetailsToItem < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :share_start_date, :date
    add_column :items, :share_end_date, :date
  end
end
