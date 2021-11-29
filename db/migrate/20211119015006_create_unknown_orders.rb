class CreateUnknownOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :unknown_orders do |t|
      t.integer :account_id
      t.date :sale_date
      t.integer :distributer_product_id

      t.timestamps
    end
  end
end
