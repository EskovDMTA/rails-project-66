module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      def show
        @repository = ::Repository.find(params[:repository_id])
        @check = ::Repository::Check.find(params[:id])
        check_result = JSON.parse(@check.check_result)
        @lint_errors = check_result['parsed_result']
        @lint_status = check_result['exit_status']
      end

      def create
        @repository = Repository.find(params[:repository_id])
        linter_client = Linter::LinterFactory.create_linter(@repository.language)
        repo_path = Linter::RepositoryDownloader.download(@repository.git_url)

        check_lint_result, error_lint_status = linter_client.lint(repo_path)
        commit_id = linter_client.current_commit(repo_path)
        unless @repository.checks.create(repo_path:, check_result: check_lint_result.to_json,
                                         status: error_lint_status, commit_id: commit_id)
          redirect_to root_path
        end
      end
    end
  end
end
