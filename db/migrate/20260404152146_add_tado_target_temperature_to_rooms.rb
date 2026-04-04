class AddTadoTargetTemperatureToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :tado_target_temperature, :float
  end
end
