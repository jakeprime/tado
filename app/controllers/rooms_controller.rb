class RoomsController < ApplicationController
  def set_temperature
    @room = Tado::Room.find(id)
    @room.target_temperature = value
  end

  def id = params[:id]
  def value = params[:value]
end
