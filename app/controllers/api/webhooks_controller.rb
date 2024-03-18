# frozen_string_literal: true

module Api
  class WebhooksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def github
      case request.headers['x-github-event']
      when 'push'
        run_lint(repository_params[:id])
        head :ok
      when 'ping'
        head :ok
      else
        render json: 'not implementer request'
      end
    end

    private

    def repository_params
      params.require('repository').permit('id')
    end

    def run_lint(git_id)
      repository = Repository.find_by(github_id: git_id)
      return unless repository

      check = repository.checks.create!
      RepositoryCheckJob.perform_inline(repository.id, check.id)
    end
  end
end
