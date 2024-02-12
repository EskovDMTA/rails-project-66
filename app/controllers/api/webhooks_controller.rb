module Api
  class WebhooksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def github
      if request.headers["x-github-event"] == "push"
        run_lint(repository_params[:id])
      else
        nil
      end
    end

    private
    def repository_params
      params.require('repository').permit('id')
    end

    def run_lint(git_id)
      repository = Repository.find_by(git_id:)
      puts repository
      puts git_id
      if repository
        client = Linter::LinterFactory.create_linter(@repository.language)
        repo_path = Linter::RepositoryDownloader.download(@repository.git_url)
        check_lint_result, error_lint_status = client.lint(repo_path)
        unless @repository.checks.create(repo_path:, check_result: check_lint_result.to_json,
                                         status: error_lint_status, commit_id: commit_id)
          redirect_to root_path
        end
      end
    end

  end

end
