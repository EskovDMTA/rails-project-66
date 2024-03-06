# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      user = User.find_by(provider: auth['provider'], uid: auth['uid']) || create_with_omniauth(auth)
      user.token = auth['credentials']['token']
      if user.save
        sign_in(user)
        redirect_to root_path, notice: t('authentication.login')
      else
        redirect_to root_path, alert: "#{t('authentication.login_error')}: #{user.errors.full_messages.join('\n')}"
      end
    end

    def destroy
      sign_out
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
