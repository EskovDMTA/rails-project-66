# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @repo = repositories(:one)
        sign_in @user
      end
      # test '#show' do
      # end
      #
      # test '#create' do
      # end
    end
  end
end
