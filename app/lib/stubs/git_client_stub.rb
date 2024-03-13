# frozen_string_literal: true

class GitClientStub
  def initialize(*) end

  def fetch_user_repositories_name_and_id
    ['eskovdmta/quality-analyzer', 510_158_155]
  end

  def fetch_repo(_github_id)
    {
      name: 'quality-analyzer',
      full_name: 'eskovdmta/quality-analyzer',
      language: 'javascript',
      git_url: 'https://github.com/eskovdmta/quality-analyzer.git',
      ssh_url: 'https://github.com/eskovdmta/quality-analyzer.git',
      github_id: 510_158_155
    }
  end
end
