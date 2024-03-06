# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    test 'should get show' do
      get web_repositories_show_url
      assert_response :success
    end

    test 'should get index' do
      get web_repositories_index_url
      assert_response :success
    end
  end
end
