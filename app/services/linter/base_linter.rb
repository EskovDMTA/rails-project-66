module Linter
  class BaseLinter
    def initialize(language = self.class)
      @language = language
    end

    def lint(file_path)
      raise NotImplementedError, "#{self.class} must implement the 'lint' method."
    end

    def run_command(command)
      stdout, exit_status = Open3.capture2e(command)
      [stdout, exit_status]
    end

    def current_commit(repo_path)
      commit_id_command = 'git log -n 1 --pretty=format:"%h"'
      Dir.chdir(repo_path) do
        stdout, exit_status = run_command(commit_id_command)
        return stdout if exit_status.exitstatus.zero?

        ''
      end
    end

    private

    def build_parsing_result(stdout, exit_status)
      { parsed_result: parsing_result(stdout), exit_status: exit_status.exitstatus }
    end
  end
end
