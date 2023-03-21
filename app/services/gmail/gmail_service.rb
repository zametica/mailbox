module Gmail
  class GmailService
    def initialize(access_token:, options: {})
      @access_token = access_token
      @options = options
    end

    private

    attr_reader :access_token, :options

    def gmail
      @gmail ||= Google::Apis::GmailV1::GmailService.new.tap do |service|
        service.authorization = Signet::OAuth2::Client.new(access_token:)
      end
    end
  end
end
