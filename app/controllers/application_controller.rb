# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :authenticate_user!

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t('authentication.logout')
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    redirect_to root_path unless current_user
  end
end
