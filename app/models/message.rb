class Message < ApplicationRecord
  extend MessageParser
  include FilterMessages

  belongs_to :user

  def self.create_from_gmail(message, **args)
    upsert(parse(message).merge(args), unique_by: :message_id)
  end
end
