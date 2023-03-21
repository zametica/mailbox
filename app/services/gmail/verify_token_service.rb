module Gmail
  class VerifyTokenService
    def self.call(access_token:)
      new(access_token).call
    end

    def initialize(access_token)
      @access_token = access_token
    end

    def call
      verify_token
    end

    private

    attr_reader :access_token

    def verify_token
      Google::Apis::Oauth2V2::Oauth2Service.new.tokeninfo(access_token:)
    end
  end
end
