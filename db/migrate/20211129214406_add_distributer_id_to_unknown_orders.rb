class AddDistributerIdToUnknownOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :unknown_orders, :distributer_id, :integer
  end
end
