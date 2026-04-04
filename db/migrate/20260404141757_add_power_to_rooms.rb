class AddPowerToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :power, :boolean
  end
end
