# frozen_string_literal: true

module Api
  class WebhooksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def github
      run_lint(repository_params[:id])

      render json: { status: 200 }
    end

    private

    def repository_params
      puts params.require(:repository)
      params.require(:repository).permit(:id)
    end

    def run_lint(git_id)
      repository = Repository.find_by(github_id: git_id)
      puts "***---REPOSITORY--***"
      puts repository
      return unless repository

      check = repository.checks.create!
      puts "***---CHECK--***"
      puts check
      RepositoryCheckJob.perform_inline(repository.id, check.id)
    end
  end
end
