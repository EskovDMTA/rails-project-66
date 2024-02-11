module Linter
  class RepositoryDownloader

    def self.download(repository_url)
      temp_repo_path = generate_temp_repository_path
      git_clone_command = "git clone #{repository_url} #{temp_repo_path}"
      stdout, exit_status = Open3.capture2e(git_clone_command)
      temp_repo_path
    end

    private

    def self.generate_temp_repository_path
      temp_path = File.join('tmp', 'repositories', SecureRandom.hex(8))
      FileUtils.mkdir_p(Rails.root.join(temp_path))
      temp_path.to_s
    end
  end
end
