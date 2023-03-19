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
      import_emails
    end

    private

    attr_reader :user_id, :user

    def find_user
      @user = User.find(user_id)
    end

    def import_emails
      return partial_import if last_history_id.present?

      full_import
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
