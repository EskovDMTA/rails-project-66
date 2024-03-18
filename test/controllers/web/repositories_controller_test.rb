# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @repo = repositories(:one)
      sign_in @user
    end

    test 'should get repositories index page' do
      get repositories_path

      assert_response :success
    end

    test '#show' do
      get repository_path(@repo)

      assert_response :success
    end

    test '#create' do
      repos_stub_request
      post repositories_path
      repository = Repository.last
      assert_equal repository.name, 'Hello-World'
      assert_equal 'git@github.com:octocat/Hello-World.git', repository.ssh_url
      assert_redirected_to repositories_path
    end

    private

    def repos_stub_request
      stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
        .to_return(body: file_fixture('response.json'), status: 200)
    end
  end
end
