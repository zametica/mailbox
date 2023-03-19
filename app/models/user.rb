class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :messages

  def self.find_by_auth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email
    user.access_token = auth.credentials.token
    user.refresh_token = auth.credentials.refresh_token
    user.save
    user
  end

  def add_message(message)
    Message.create_from_gmail(message, user_id: id)
  end
end
