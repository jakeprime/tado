module Tado
  class Auth
    CLIENT_ID = "1bb50063-6b0c-4d11-bd99-387f4a91cc46"
    LOGIN_SITE = "https://login.tado.com"

    DEVICE_GRANT_TYPE = "urn:ietf:params:oauth:grant-type:device_code"

    def token
      stored_token = Tado::Token.token
      return nil if stored_token.nil?

      token = OAuth2::AccessToken.new(
        client,
        stored_token.access_token,
        refresh_token: stored_token.refresh_token,
        expires_at: stored_token.expires_at,
      )

      if token.expired?
        token.refresh!
        Tado::Token.persist(token)
      end

      token
    rescue OAuth2::Error
      nil
    end

    def client
      @client ||= OAuth2::Client.new(
        CLIENT_ID,
        nil,
        site: LOGIN_SITE,
        token_url: "/oauth2/token",
        auth_scheme: :request_body,
        token_method: :post
      )
    end

    def start_device_flow
      scope = :offline_access

      response = client.request(
        :post,
        "/oauth2/device_authorize",
        params: {
          client_id: CLIENT_ID,
          scope:,
        }.compact,
        parse: :json
      )

      unless response.status.between?(200, 299)
        raise "Device authorization failed: HTTP #{response.status} #{response.body}"
      end

      response.parsed
    end

    def poll_for_token(device_code:, interval:, timeout: 300)
      deadline = timeout.seconds.from_now
      current_interval = interval

      loop do
        raise "Timed out waiting for user authorization" if Time.current >= deadline

        token = client.get_token(
          grant_type: DEVICE_GRANT_TYPE,
          device_code:,
          parse: :json
        )

        if token.is_a?(OAuth2::AccessToken) && token.token.present?
          return token
        end
      rescue OAuth2::Error => e
        case e.code
        when "authorization_pending"
          sleep current_interval
        when "slow_down"
          current_interval += 5
          sleep current_interval
        else
          raise
        end
      end
    end
  end
end
