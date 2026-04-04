class RoomsController < ApplicationController
  def set_temperature
    @room = Room.find(id)
    @room.update(target_temperature: value)

    TadoSyncJob.perform_now
  end

  def id = params[:id]
  def value = params[:value]
end
