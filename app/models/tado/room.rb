module Tado
  class Room
    include ActiveModel::Model

    def self.raw
      Tado::Api::Rooms.list
    end

    def self.all
      raw.map { new(it) }
    end

    def self.find(id)
      all.find { it.id == id.to_i }
    end

    attr_reader :id, :name, :current_temperature, :target_temperature, :power, :termination

    def initialize(raw)
      @id = raw["id"]
      @name = raw["name"]
      @current_temperature = raw.dig(*%w[sensorDataPoints insideTemperature value])
      @power = raw.dig(*%w[setting power])
      @target_temperature = raw.dig(*%w[setting temperature value]) || 0
      @termination = raw["manualControlTermination"]
    end

    def target_temperature=(value)
      @target_temperature = value.to_f
      Tado::Api::Rooms.set_target_temperature(self)
    end
  end
end
