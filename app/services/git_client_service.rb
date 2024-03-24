# frozen_string_literal: true

class GitClientService
  def initialize(access_token)
    @access_token = access_token
  end

  def fetch_user_repositories_name_and_id
    relevant_languages = %w[JavaScript Ruby]
    user_repositories.select { |repo| relevant_languages.include?(repo.language) }
                     .sort_by(& :full_name)
                     .map { |repo| [repo.full_name, repo.id] }
  end

  def repository_params(git_hub_repo_id)
    current_repo = user_repositories.find { |repo| repo[:id] == git_hub_repo_id.to_i }
    {
      name: current_repo[:name],
      full_name: current_repo[:full_name],
      language: current_repo[:language].downcase,
      git_url: current_repo[:clone_url],
      ssh_url: current_repo[:ssh_url],
      github_id: git_hub_repo_id.to_i
    }
  end

  private

  def client
    Octokit::Client.new(access_token: @access_token, auto_paginate: true)
  end

  def user_repositories
    client.repos
  end
end
