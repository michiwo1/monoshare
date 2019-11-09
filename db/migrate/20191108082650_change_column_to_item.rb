class ChangeColumnToItem < ActiveRecord::Migration[6.0]
  def change

    def up
       change_column :items, :share_start_date, :date, null: false, default: 0
    end

    def down
       change_column :items, :share_start_date, :date
    end

    def up
       change_column :items, :share_end_date, :date, null: false, default: 0
    end

    def down
       change_column :items, :share_end_date, :date
    end
  end
end
