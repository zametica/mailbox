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
      raise NotImplementedError
    end

    private

    attr_reader :user, :access_token
  end
end
