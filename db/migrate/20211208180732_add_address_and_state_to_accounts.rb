class AddAddressAndStateToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :address, :string
    add_column :accounts, :state, :string
    add_column :accounts, :city, :string
  end
end
