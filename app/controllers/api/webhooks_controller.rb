# frozen_string_literal: true

module Api
  class WebhooksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def github
      return unless request.headers['x-github-event'] == 'push'

      run_lint(repository_params[:id])
    end

    private

    def repository_params
      params.require('repository').permit('id')
    end

    def run_lint(git_id)
      repository = Repository.find_by(git_id:)
      return unless repository

      check = repository.checks.create!
      RepositoryCheckJob.perform_later(repository.id, check.id)
    end
  end
end
