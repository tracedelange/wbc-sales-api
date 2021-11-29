class AddPremiseTypeAndCoordinatesToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :on_premise, :boolean
    add_column :accounts, :latitude, :integer
    add_column :accounts, :longitude, :integer
  end
end
