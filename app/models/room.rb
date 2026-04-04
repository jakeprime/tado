class Room < ApplicationRecord
  def termination_seconds_from_now
    return nil unless termination_type == "TIMER"

    DateTime.parse(JSON.parse(termination)["projectedExpiry"]).to_i - Time.current.to_i
  end

  def termination_type
    return "NEXT_TIME_BLOCK" unless termination && JSON.parse(termination)

    JSON.parse(termination)["type"]
  end
end
