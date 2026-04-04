module Tado
  module Api
    class Base
      API_SITE = "https://hops.tado.com"

      def client
        auth = Tado::Auth.new
        token = auth.token

        client = OAuth2::Client.new(
          Tado::Auth::CLIENT_ID,
          nil,
          site: API_SITE,
          raise_errors: true
        )

        OAuth2::AccessToken.new(
          client,
          token.token,
          refresh_token: token.refresh_token,
          expires_at: token.expires_at,
        )
      end
    end
  end
end
