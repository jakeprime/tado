module Tado
  module Api
    class Rooms < Base
      def self.list
        Rails.cache.fetch("Tado::Api::Rooms.list", expires_in: 5.seconds) do
          new.client.get("/homes/2123312/rooms").parsed
        end
      end

      def self.set_target_temperature(room)
        power = room.power ? :ON : :OFF
        temperature = { value: 30.0 } if room.power

        payload = {
          setting: {
            power:,
            temperature:,
          },
          termination: { type: :NEXT_TIME_BLOCK },
        }

        new.client.post(
          "/homes/2123312/rooms/#{room.tado_id}/manualControl",
          headers: { "Content-Type" => "application/json" },
          body: payload.to_json,
        )
      end

      def self.update_temperatures(rooms)
        rooms.each do |room|
          room.power = room.target_temperature > room.current_temperature
          next unless room.power_changed?

          room.save
          set_target_temperature(room)
        end
      end
    end
  end
end
