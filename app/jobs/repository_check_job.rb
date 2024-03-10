# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(repository_id, check_id)
    repository = Repository.find(repository_id)
    check = Repository::Check.find(check_id)
    linter_client = Linter::LinterFactory.create_linter(repository.language)
    repo_path = Linter::RepositoryDownloader.download(repository.git_url)

    check.run!
    check_result = linter_client.lint(repo_path)
    commit_id = linter_client.current_commit(repo_path)

    if check_result[:exit_status].zero?
      check.status = true
    else
      check.status = false
      CheckMailer.check_failure_email(repository).deliver_now
    end
    check.finish!
    check.update!(repo_path:, check_result: check_result.to_json, commit_id:)
  ensure
    Linter::RepositoryDownloader.clean_up(repo_path) if repo_path
  end
end
