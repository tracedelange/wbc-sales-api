class ChangeAccountCoordinatesToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :accounts, :latitude, :float
    change_column :accounts, :longitude, :float
  end
end
