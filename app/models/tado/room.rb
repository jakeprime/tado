module Tado
  class Room
    def self.raw
      Tado::Api::Rooms.list
    end

    def self.all
      raw.map { new(it) }
    end

    def self.find(id)
      all.find { it.id == id.to_i }
    end

    attr_reader :id, :name, :current_temperature, :target_temperature

    def initialize(raw)
      @id = raw["id"]
      @name = raw["name"]
      @current_temperature = raw.dig(*%w[sensorDataPoints insideTemperature value])
      @target_temperature = raw.dig(*%w[setting temperature value]) || 5
    end

    def target_temperature=(value)
      @target_temperature = value
      Tado::Api::Rooms.set_target_temperature(self)
    end

    def to_partial_path
      "rooms/room"
    end
  end
end
