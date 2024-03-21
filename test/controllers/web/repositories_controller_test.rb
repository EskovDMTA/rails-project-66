# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @repo = repositories(:one)
      sign_in @user
    end

    test '#index if user authenticate' do
      get repositories_path
      assert_response :success
    end

    test '#show' do
      get repository_path(@repo)
      assert_response :success
    end

    test '#new' do
      get new_repository_path
      assert_response :success
    end

    test '#create' do
      repository_params = { github_id: 1_111_111 }
      repos_stub_request
      post repositories_path params: { repository: repository_params }

      repository = Repository.last
      assert_equal repository.name, 'javascript/repo'
      assert_equal repository.github_id, 1_111_111.to_s
      assert_equal 'github.git/eskovdmta/ruby_repo', repository.ssh_url
    end

    private

    def repos_stub_request
      stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
        .to_return(body: file_fixture('response.json'), status: 200)
    end
  end
end
