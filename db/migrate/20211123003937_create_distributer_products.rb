class CreateDistributerProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :distributer_products do |t|
      t.string :name
      t.integer :product_id
      t.integer :distributer_id

      t.timestamps
    end
  end
end
