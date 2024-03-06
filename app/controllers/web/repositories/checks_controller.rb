# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      def show
        @repository = ::Repository.find(params[:repository_id])
        @check = ::Repository::Check.find(params[:id])
        check_result = JSON.parse(@check.check_result)
        @lint_errors = check_result['parsed_result']
        @lint_status = check_result['exit_status']
        @errors_count = check_result['error_count']
      end

      def create
        @repository = Repository.find(params[:repository_id])
        check = @repository.checks.create!

        RepositoryCheckJob.perform_later(@repository.id, check.id)
        redirect_to repository_path(@repository), notice: 'Check has been scheduled'
      end
    end
  end
end
