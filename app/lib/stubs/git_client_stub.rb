# frozen_string_literal: true

module Stubs
  class GitClientStub
    def initialize(*) end

    def repository_params(_git_hub_repo_id)
      current_repo = user_repositories.filter { |repo| repo[:id] == 1_296_269 }.first
      puts 'current_repo'
      puts current_repo
      {
        name: current_repo[:name],
        full_name: current_repo[:full_name],
        language: current_repo[:language].downcase,
        git_url: current_repo[:clone_url],
        ssh_url: current_repo[:ssh_url],
        github_id: 1_296_269
      }
    end

    def fetch_user_repositories_name_and_id
      # user_repositories.select { |repo| repo[:language] == 'javascript' || repo[:language] == 'ruby' }
      #                  .sort_by { |repo| repo[:full_name] }
      #                  .map { |repo| [repo[:full_name], repo[:id]] }
      ['octocat/Hello-World', 1_296_269]
    end

    def client
      Octokit::Client.new(access_token: @access_token, auto_paginate: true)
    end

    def user_repositories
      json_data = File.read('test/fixtures/files/response.json')
      JSON.parse(json_data, symbolize_names: true)
    end
  end
end
