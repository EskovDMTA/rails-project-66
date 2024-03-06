# frozen_string_literal: true

module AuthManagment
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    reset_session
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    return if current_user.present?

    redirect_back fallback_location: root_path, alert: t('bulletin_policy.login_or_registration', scope: 'pundit')
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  private

  def reset_session
    session[:user_id] = nil
    @current_user = nil
  end
end
