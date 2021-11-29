class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :account_name
      t.integer :distributer_id

      t.timestamps
    end
  end
end
