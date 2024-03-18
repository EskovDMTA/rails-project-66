# frozen_string_literal: true

module Linter
  class RubyLinter < BaseLinter
    def lint(repo_path = nil)
      repo_path = if repo_path.nil?
                    Dir.glob(Rails.root.join('tmp', 'repository', '*')).first
                  else
                    Rails.root.join(repo_path.to_s)
                  end
      puts "******repo_path******"
      puts repo_path

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
