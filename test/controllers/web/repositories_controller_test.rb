# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repo = repositories(:one)
    sign_in @user
  end

  test '#index' do
    get repositories_path

    assert_response :success
  end

  test 'with not auth user' do
    delete session_path

    get repositories_path

    assert_redirected_to root_path default_url_options
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
    attrs = {
      github_id: 1_296_269
    }

    post repositories_path, params: { repository: attrs }
    new_repo = Repository.find_by(attrs.merge({ user_id: @user.id, full_name: 'octocat/Hello-World' }))

    assert { new_repo }
    assert_redirected_to repositories_path default_url_options
  end
end
