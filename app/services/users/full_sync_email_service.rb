module Users
  class FullSyncEmailService
    def self.call(user:)
      new(user).call
    end

    def initialize(user)
      @user = user
    end

    def call = import_messages

    private

    attr_reader :user

    def import_messages
      Gmail::FetchMessagesService.new(
        access_token: user.access_token,
        refresh_token: user.refresh_token
      ).call do |result, _error|
        # TODO: reschedule the worker if _error.present?
        user.add_message!(result)
      end
    end
  end
end
