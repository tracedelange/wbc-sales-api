class CreateReportReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :report_receipts do |t|

      t.integer :distributer_id
      t.integer :assigned_order_count
      t.integer :unassigned_order_count
      t.integer :new_account_count

      t.timestamps
    end
  end
end
