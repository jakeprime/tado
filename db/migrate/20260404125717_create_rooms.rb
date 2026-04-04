class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.integer :tado_id
      t.string :name
      t.float :current_temperature
      t.float :target_temperature

      t.timestamps
    end
  end
end
