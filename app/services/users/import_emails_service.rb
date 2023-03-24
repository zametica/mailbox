module Users
  class ImportEmailsService
    def self.call(access_token:)
      new(access_token).call
    end

    def initialize(access_token)
      @access_token = access_token
    end

    def call
      find_user
      import_emails
      reschedule_worker
    end

    private

    attr_reader :access_token, :user

    def find_user
      @user = User.find_by!(email:)
    rescue ActiveRecord::RecordNotFound
      raise UnrecoverableError, 'User not found'
    end

    def email
      @email ||= Gmail::VerifyTokenService.call(access_token:)&.email
    rescue Google::Apis::Error
      raise UnrecoverableError, 'Unauthorized'
    end

    def import_emails
      SyncEmailService.call(user:, access_token:)
    rescue
      byebug
    end

    def reschedule_worker
      SyncEmailsWorker.perform_in(1.minute, access_token)
    end
  end
end
