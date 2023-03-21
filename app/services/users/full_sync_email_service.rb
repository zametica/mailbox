module Users
  class FullSyncEmailService < SyncEmailService
    def call
      Gmail::FetchMessagesService.new(
        access_token:
      ).call do |result, _error|
        # TODO: reschedule the worker if _error.present?
        user.add_message(result)
      end
    end
  end
end
