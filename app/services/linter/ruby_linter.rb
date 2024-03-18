# frozen_string_literal: true

module Linter
  class RubyLinter < BaseLinter
    attr_accessor :repo_path
    def lint
      command = "bundle exec rubocop --safe --format json #{repo_path}"

      result = CommandRunner.run(command)
      build_parsing_result(result[:stdout], result[:exit_status])
    end

    private

    def parsing_result(linter_result)
      puts "****-LINTERRESULT-****"
      puts linter_result
      json_result = JSON.parse(linter_result, symbolize_names: true)
      json_result[:files].reject { |file| file[:offenses].empty? }
    end

    def count_errors(stdout)
      parsing_result(stdout).sum { |file| file[:offenses].size }
    end
  end
end
