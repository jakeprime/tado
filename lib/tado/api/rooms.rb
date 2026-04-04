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
        temperature = { value: room.tado_target_temperature } if room.power
        termination = {
          type: room.termination_type,
          durationInSeconds: room.termination_seconds_from_now,
        }.compact

        payload = {
          setting: {
            power:,
            temperature:,
          },
          termination:,
        }

        new.client.post(
          "/homes/2123312/rooms/#{room.tado_id}/manualControl",
          headers: { "Content-Type" => "application/json" },
          body: payload.to_json,
        )
      end

      def self.update_temperatures(rooms)
        rooms.each do |room|
          if room.target_temperature == 0.0
            room.power = false
          else
            room.power = true
            room.tado_target_temperature = room.target_temperature > room.current_temperature ? 30.0 : 5.0
          end
          next unless room.power_changed? || room.tado_target_temperature_changed?

          room.save
          set_target_temperature(room)
        end
      end
    end
  end
end
