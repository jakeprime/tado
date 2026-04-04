class TadoSyncJob < ApplicationJob
  queue_as :default

  def perform
    tado_rooms = Tado::Room.all

    tado_rooms.each do |tado_room|
      room = Room.find_or_create_by(tado_id: tado_room.id) do |r|
        r.name = tado_room.name
        r.target_temperature = tado_room.target_temperature
      end

      room.current_temperature = tado_room.current_temperature
      room.tado_target_temperature = tado_room.target_temperature
      room.power = tado_room.power == "ON"

      if tado_room.power == "OFF"
        room.target_temperature = 0.0 # < 5 is not valid, but we'll use 0 to indicate OFF
        room.tado_target_temperature = 0.0
      elsif tado_room.target_temperature.in?(5.1...29.0)
        # If the target temp is not either max or min then someone has manually set that and we
        # should respect it
        room.target_temperature = tado_room.target_temperature
      end

      room.save
    end

    Tado::Api::Rooms.update_temperatures(Room.all)
  end
end
