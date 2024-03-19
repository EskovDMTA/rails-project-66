# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def github
      return render json: { message: 'not implemented' } unless request.headers == 'push'

      run_lint(repository_params[:id])
      head :ok
    end

    private

    def repository_params
      params.require(:repository).permit(:id)
    end

    def run_lint(git_id)
      puts git_id
      repository = Repository.find_by(github_id: git_id)
      puts repository
      return unless repository

      check = repository.checks.create!
      RepositoryCheckJob.perform_inline(repository.id, check.id)
    end
  end
end
