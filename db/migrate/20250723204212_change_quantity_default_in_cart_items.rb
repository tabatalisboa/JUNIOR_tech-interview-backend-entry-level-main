class ChangeQuantityDefaultInCartItems < ActiveRecord::Migration[7.1]
  def change
    change_column :cart_items, :quantity, :integer, default: 1, null: false
  end
end