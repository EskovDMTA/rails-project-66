module Linter
  class RepositoryDownloader
    def self.download(repository_url)
      temp_repo_path = generate_temp_repository_path
      result = CommandRunner.run("git clone #{repository_url} #{temp_repo_path}")
      temp_repo_path if result[:exit_status].zero?
    end

    def self.clean_up(repo_path)
      FileUtils.rm_rf(repo_path) if Dir.exist?(repo_path)
    rescue StandardError => e
      Rails.logger.error "Failed to clean up the repository at #{repo_path}: #{e.message}"
    end

    private

    def self.generate_temp_repository_path
      temp_path = File.join('tmp', 'repositories', SecureRandom.hex(8))
      FileUtils.mkdir_p(Rails.root.join(temp_path))
      temp_path
    end
  end
end
