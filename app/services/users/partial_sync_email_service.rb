module Users
  class PartialSyncEmailService
    # There is a limitation with history -
    # As per google docs history records are typically available for at least one week and often longer,
    # but there is also another approach with utilizing push notifications
    # check (https://developers.google.com/gmail/api/guides/push)
    def self.call(user:, history_id:)
      new(user, history_id).call
    end

    def initialize(user, history_id)
      @user = user
      @history_id = history_id
    end

    def call = import_messages

    private

    attr_reader :user, :history_id

    def import_messages
      Gmail::FetchHistoryService.new(
        access_token: user.access_token,
        refresh_token: user.refresh_token,
        options: {
          history_id:
        }
      ).call do |result|
        user.add_message!(result)
      end
    end
  end
end
