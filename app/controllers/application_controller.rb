# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthManagment
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method %i[current_user sign_in signed_in? sign_out authenticate_user!]
end
