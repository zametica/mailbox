module Users
  class SyncEmailService
    def self.call(user:, access_token:)
      new(user, access_token).call
    end

    def initialize(user, access_token)
      @user = user
      @access_token = access_token
    end

    def call
      sync_service.call do |result, _error|
        user.add_message(result)
      end
    end

    private

    attr_reader :user, :access_token

    def sync_service
      if user.last_history_id.present?
        return Gmail::FetchHistoryService.new(
          access_token:,
          options: {
            history_id: user.last_history_id
          }
        )
      end

      Gmail::FetchMessagesService.new(access_token:)
    end
  end
end
