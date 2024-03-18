# frozen_string_literal: true

module Stubs
  class GitClientStub
    def initialize(*) end

    def repository_params(git_hub_repo_id)
      current_repo = user_repositories.filter { |repo| repo[:id] == 2 }.first
      {
        name: current_repo[:name],
        full_name: current_repo[:full_name],
        language: current_repo[:language].downcase,
        git_url: current_repo[:clone_url],
        ssh_url: current_repo[:ssh_url],
        github_id: git_hub_repo_id
      }
    end

    def fetch_user_repositories_name_and_id
      user_repositories.select { |repo| repo.language == 'JavaScript' || repo.language == 'Ruby' }
                       .sort_by(& :full_name)
                       .map { |repo| [repo.full_name, repo.id] }
    end

    def client
      Octokit::Client.new(access_token: @access_token, auto_paginate: true)
    end

    def user_repositories
      JSON.parse(client.repos, symbolize_names: true)
    end
  end
end
