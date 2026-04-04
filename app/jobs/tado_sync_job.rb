class TadoSyncJob < ApplicationJob
  queue_as :default

  def perform
    tado_rooms = Tado::Room.all

    tado_rooms.each do |tado_room|
      room = Room.find_or_create_by(tado_id: tado_room.id) do |r|
        r.name = tado_room.name
        r.name = tado_room.name
        r.target_temperature = tado_room.target_temperature
      end

      room.update(
        current_temperature: tado_room.current_temperature,
      )
    end
  end
end
