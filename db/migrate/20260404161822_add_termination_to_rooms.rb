class AddTerminationToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :termination, :string
  end
end
