# frozen_string_literal: true

module Linter
  class BaseLinter
    def initialize(language = self.class)
      @language = language
    end

    def lint(file_path)
      raise NotImplementedError, "#{self.class} must implement the 'lint' method."
    end

    def current_commit(repo_path)
      result = CommandRunner.run('git log -n 1 --pretty=format:"%h"', chdir: Rails.root.join(repo_path))
      result[:exit_status].zero? ? result[:stdout].strip : ''
    end

    def build_parsing_result(stdout, exit_status)
      {
        parsed_result: parsing_result(stdout),
        error_count: count_errors(stdout),
        exit_status:
      }
    end

    private

    def parsing_result(stdout)
      raise NotImplementedError, "#{self.class} must implement the 'parsing_result' method."
    end

    def count_errors(stdout)
      raise NotImplementedError, "#{self.class} must implement the 'count_errors' method."
    end
  end
end
