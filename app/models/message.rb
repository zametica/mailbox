class Message < ApplicationRecord
  extend MessageParser
  include FilterMessages

  belongs_to :user

  def self.create_from_gmail!(message, **args)
    create!(parse(message).merge(args))
  end
end
