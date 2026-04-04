module Tado
  class Token < ApplicationRecord
    self.table_name = "tado_tokens"

    def self.token = Token.last

    def self.persist(oauth_token)
      token = Token.last || Token.new
      token.update(
        access_token: oauth_token.token,
        refresh_token: oauth_token.refresh_token,
        expires_at: oauth_token.expires_at,
      )
    end
  end
end
