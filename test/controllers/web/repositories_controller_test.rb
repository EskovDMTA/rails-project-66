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

    test '#new' do
      get new_repository_path

      assert_response :success
    end

    test '#create' do
      stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
        .to_return(body: file_fixture('hexlet-friends.json'), status: 200)
      post repositories_path
      repository = Repository.last
      puts repository
      assert_equal repository.link, 'https://github.com/octokit/octokit.rb'
      assert_equal "This your first repo!", repository.description
      assert_redirected_to root_path
    end
  end
end
