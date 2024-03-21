# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @repo = repositories(:one)
        @check = repository_checks(:one)

        sign_in @user
      end

      test '#show' do
        get repository_check_path(@repo, @check)
        assert_response :success
      end

      test '#create' do
        repo_without_check = repositories(:without_checks)
        post repository_checks_path(repo_without_check)

        check = repo_without_check.checks.last
        assert check.finished?
        assert check.passed == true
      end
    end
  end
end
