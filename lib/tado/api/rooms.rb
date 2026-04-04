module Tado
  module Api
    class Rooms < Base
      def self.get
        new.client.get("/homes/2123312/rooms").parsed
      end
    end
  end
end
