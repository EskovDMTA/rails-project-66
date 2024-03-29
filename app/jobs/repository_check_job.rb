# frozen_string_literal: true

class RepositoryCheckJob
  include Sidekiq::Job
  queue_as :default
  sidekiq_options retry: 0

  def perform(repository_id, check_id)
    repository = Repository.find(repository_id)
    check = Repository::Check.find(check_id)
    linter_client = Linter::BaseLinterService.build_linter_client(repository.language)
    repo_path = Linter::DownloadRepositoryService.download(repository.git_url)

    check.run!
    check_result = linter_client.perform(repo_path)
    commit_id = linter_client.current_commit(repo_path)

    if check_result[:exit_status].zero?
      check.passed = true
    else
      check.passed = false
      CheckMailer.check_failure_email(repository).deliver_now
    end
    check.finish!
    check.update!(repo_path:, check_result: check_result.to_json, commit_id:)
  ensure
    Linter::DownloadRepositoryService.clean_up(repo_path) if repo_path
  end
end
