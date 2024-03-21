# frozen_string_literal: true

module Stubs
  class GitClientStub
    def initialize(*) end

    def repository_params(git_hub_repo_id)
      {
        name: 'javascript/repo',
        full_name: 'eskovdmta/javascript_repo',
        language: 'javascript',
        git_url: 'http://github.git/eskovdmta/ruby_repo',
        github_id: git_hub_repo_id,
        ssh_url: 'github.git/eskovdmta/ruby_repo'
      }
    end

    def fetch_user_repositories_name_and_id
      ['octocat/Hello-World', 1_111_111]
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
