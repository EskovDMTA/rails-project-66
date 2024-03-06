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
      if repository
        check = repository.checks.create!
        RepositoryCheckJob.perform_later(repository.id, check.id)
        redirect_to repository_path(@repository), notice: "Check has been scheduled"
      #   test webhook
      end
    end

  end

end
