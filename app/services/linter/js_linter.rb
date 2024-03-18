# frozen_string_literal: true

# # frozen_string_literal: true

module Linter
  class JsLinter < BaseLinter
    def lint(repo_path)
      absolute_repo_path = Rails.root.join(repo_path.to_s) unless repo_path.nil?
      result = CommandRunner.run(
        "yarn run eslint --format json -c #{Rails.root.join('.eslintrc.js')} #{absolute_repo_path}"
      )
      build_parsing_result(result[:stdout], result[:exit_status])
    end

    private

    def parsing_result(lint_errors)
      lint_result_without_system_msg = lint_errors.split("\n")[2]

      lint_errors = JSON.parse(lint_result_without_system_msg, symbolize_names: true)
      lint_errors.map { |item| { item[:filePath] => parse_error(item) } }
    end

    def parse_error(error)
      error[:messages].each { |msg| format_message(msg) }
    end

    def format_message(msg)
      { 'message' => msg[:message], 'line' => "#{msg[:line]}:#{msg[:column]}", 'rule_id' => msg[:ruleId] }
    end

    def count_errors(stdout)
      lint_errors = parsing_result(stdout)
      lint_errors.sum { |error_file| error_file.values.first.count }
    end
  end
end
