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

  def add_message!(message)
    Message.create!(
      user: self,
      message_id: message.id,
      history_id: message.history_id,
      thread_id: message.thread_id,
      subject: message_header(message, 'Subject'),
      sender: message_header(message, 'From'),
      recipient: message_header(message, 'Delivered-To'),
      body: message.payload.parts.map(&:body).map(&:data).join(''),
      sent_at: Time.at(message.internal_date).to_datetime
    )
  end

  private

  def message_header(message, name)
    message.payload.headers.find { |h| h.name == name }&.value
  end
end
