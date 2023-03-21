module Api
  class AuthController < ApiController
    def show
      schedule_sync
      render json: access_token
    end

    private

    def schedule_sync
      SyncEmailsWorker.perform_async(access_token['access_token'])
    end

    def access_token
      @access_token ||= client.fetch_access_token!
    rescue Signet::AuthorizationError
      head :unauthorized
    end
  end
end
