module Gmail
  class GmailMessagesService
    def initialize(access_token:, options: {})
      @access_token = access_token
      @options = options
    end

    def call(&callback)
      message_ids.each_slice(100) do |ids_batch|
        gmail.batch do |gm|
          ids_batch.each do |id|
            gm.get_user_message('me', id, &callback)
          end
        end
      end
    end

    def message_ids
      raise NotImplementedError, "#{self.class.inspect} needs to implement message_ids method"
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
