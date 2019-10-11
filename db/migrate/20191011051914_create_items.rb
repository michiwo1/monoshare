class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :tittle
      t.text :content
      t.integer :state
      t.string :image
      t.integer :share_start_date
      t.integer :share_end_date

      t.timestamps
    end
  end
end
