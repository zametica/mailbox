module Api
  class ApiController < ::ApplicationController
    def user
      @user ||= User.find_by!(email: id_token['email'])
    end

    private

    def client
      @client ||=
        Signet::OAuth2::Client.new(
          client_id: ENV['GOOGLE_CLIENT_ID'],
          client_secret: ENV['GOOGLE_CLIENT_SECRET'],
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          code: params[:code],
          scope: 'https://www.googleapis.com/auth/gmail.readonly',
          redirect_uri: 'postmessage',
          grant_type: 'authorization_code'
        )
    end

    def auth_header = @auth_header ||= request.headers['Authorization']

    def id_token
      # we could also call Gmail::VerifyTokenService to verify access_token instead
      @id_token ||=
        begin
          client.id_token = request.headers['Id']
          client.decoded_id_token
        end
    end
  end
end
