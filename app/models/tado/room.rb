module Tado
  class Room
    def self.raw
      Tado::Api::Rooms.get
    end

    def self.all
      raw.map { new(it) }
    end

    attr_reader :name, :current_temperature

    def initialize(raw)
      @name = raw["name"]
      @current_temperature = raw.dig(*%w[sensorDataPoints insideTemperature value])
    end
  end
end
