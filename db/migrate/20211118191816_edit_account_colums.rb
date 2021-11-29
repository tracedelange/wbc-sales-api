class EditAccountColums < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :display_name, :string
  end
end
