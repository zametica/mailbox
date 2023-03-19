# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def destroy
    current_user.update(access_token: nil, refresh_token: nil)
    super
  end
end
