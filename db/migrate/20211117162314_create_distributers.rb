class CreateDistributers < ActiveRecord::Migration[6.1]
  def change
    create_table :distributers do |t|
      t.string :name

      t.timestamps
    end
  end
end
