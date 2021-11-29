class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :account_id
      t.date :sale_date
      t.integer :product_id

      t.timestamps
    end
  end
end
