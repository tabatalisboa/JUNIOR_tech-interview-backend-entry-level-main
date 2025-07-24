class AddAbandonedToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :abandoned, :boolean, default: false, null: false
    add_column :carts, :abandoned_at, :datetime
    add_column :carts, :last_interaction_at, :datetime

    add_index :carts, :abandoned
    add_index :carts, :abandoned_at
    add_index :carts, :last_interaction_at
  end
end
