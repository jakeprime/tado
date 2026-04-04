class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :ensure_authorized

  def index
    @rooms = Tado::Api::Rooms.get
  end

  def ensure_authorized
    auth = Tado::Auth.new
    return unless auth.token.nil?

    device_data = Rails.cache.fetch("device_data")

    if device_data
      token = auth.poll_for_token(
        device_code: device_data["device_code"],
        interval: device_data["interval"],
        timeout: device_data["expires_in"],
      )

      Tado::Token.persist(token)
      Rails.cache.delete("device_data")

      return
    end

    device_data = auth.start_device_flow
    Rails.cache.write("device_data", device_data, expires_in: 5.minutes)

    redirect_to device_data["verification_uri_complete"], allow_other_host: true
  end
end
