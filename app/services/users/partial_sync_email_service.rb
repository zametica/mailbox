module Users
  class PartialSyncEmailService < SyncEmailService
    # There is a limitation with history -
    # As per google docs history records are typically available for at least one week and often longer,
    # but there is also another approach with utilizing push notifications
    # check (https://developers.google.com/gmail/api/guides/push)
    def call
      Gmail::FetchHistoryService.new(
        access_token:,
        options: {
          history_id: user.last_history_id
        }
      ).call do |result|
        user.add_message(result)
      end
    end
  end
end
