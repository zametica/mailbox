module Users
  class ImportEmailsService
    def self.call(user_id:)
      new(user_id).call
    end

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      find_user

      # to break the sync it would be better to track
      # the activity on mails endpoint
      # rather than reschedule the worker
      return if user.access_token.blank?

      import_emails
      reschedule_worker
    end

    private

    attr_reader :user_id, :user

    def find_user
      @user = User.find(user_id)
    rescue ActiveRecord::RecordNotFound
      raise UnrecoverableError, 'User not found'
    end

    def import_emails
      return partial_import if last_history_id.present?

      full_import
    rescue Signet::AuthorizationError
      raise UnrecoverableError, 'Authorization failed'
    end

    def reschedule_worker
      SyncEmailsWorker.perform_in(1.minute, user_id)
    end

    def full_import
      FullSyncEmailService.call(user:)
    end

    def partial_import
      PartialSyncEmailService.call(user:, history_id: last_history_id)
    end

    def last_history_id
      @last_history_id ||= user.messages.order(history_id: :desc).pick(:history_id)
    end
  end
end
