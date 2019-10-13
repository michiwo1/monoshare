class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :self_introduction, :text
    add_column :users, :request, :text
  end
end
