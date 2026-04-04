class RoomsController < ApplicationController
  def set_temperature
    @room = Room.find(id)
    @room.update(target_temperature: value)
    Tado::Api::Rooms.set_target_temperature(@room)
  end

  def id = params[:id]
  def value = params[:value]
end
