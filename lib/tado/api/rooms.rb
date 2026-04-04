module Tado
  module Api
    class Rooms < Base
      def self.list
        Rails.cache.fetch("Tado::Api::Rooms.list", expires_in: 5.seconds) do
          new.client.get("/homes/2123312/rooms").parsed
        end
      end

      def self.set_target_temperature(room)
        payload = {
          setting: {
            power: :ON,
            temperature: {
              value: room.target_temperature,
            },
          },
          termination: { type: :NEXT_TIME_BLOCK },
        }

        new.client.post(
          "/homes/2123312/rooms/#{room.tado_id}/manualControl",
          headers: { "Content-Type" => "application/json" },
          body: payload.to_json,
        )
      end
    end
  end
end
