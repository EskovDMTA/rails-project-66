# frozen_string_literal: true

require 'test_helper'

module Web
  module Api
    class WebhooksControllerTest < ActionDispatch::IntegrationTest
      test '#webhooks' do
        repository = repositories(:without_checks)
        repo_data = {
          repository: {
            id: repository.github_id,
            full_name: repository.full_name
          }
        }

        post api_checks_path, params: repo_data, as: :json
        assert_response :ok
        check = repository.checks.last
        assert check
        assert check.finished?
        assert check.passed?
      end
    end
  end
end
