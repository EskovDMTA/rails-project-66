# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      before_action :find_repository

      def show
        @check = ::Repository::Check.find(params[:id])
        authorize @check
        parse_check_result(@check)
      end

      def create
        check = @repository.checks.create!

        RepositoryCheckJob.perform_inline(@repository.id, check.id)
        redirect_to repository_path(@repository), notice: t('.check_start')
      end

      private

      def find_repository
        @repository = ::Repository.find(params[:repository_id])
      end

      def parse_check_result(check)
        return if check.check_result.nil?

        check_result = JSON.parse(check.check_result)
        @lint_errors, @lint_status, @errors_count = check_result.values_at('parsed_result', 'exit_status', 'error_count')
      end
    end
  end
end
