# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      user = User.find_by(provider: auth['provider'], uid: auth['uid']) || create_with_omniauth(auth)
      user.token = auth['credentials']['token']
      user.save
      session[:user_id] = user.id
      redirect_to root_path, notice: t('authentication.login')
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: t('authentication.logout')
    end

    private

    def create_with_omniauth(auth)
      User.create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        user.name = auth['info']['name']
        user.nickname = auth['info']['name']
        user.email = auth['info']['email']
        user.image_url = auth['info']['image']
        user.token = auth['credentials']['token']
      end
    end
  end
end
