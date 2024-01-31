# frozen_string_literal: true

module Linter
  class JsLinter < BaseLinter
    def lint(repo_path)
      eslint_command = "yarn eslint --format json #{repo_path}"
      stdout, exit_status = run_command(eslint_command)
      build_parsing_result(stdout, exit_status)
    end

    private

    def parsing_result(lint_errors)
      lint_result_without_system_msg = lint_errors.split("\n")[2]
      json_lint_result = JSON.parse(lint_result_without_system_msg, symbolize_name: true)
      json_lint_result.map do |item|
        item["messages"] = parse_error_line(item)
        item
      end
    end

    def parse_error_line(error_line)
      error_line['messages'].map do |msg|
        { 'message' => msg['message'],
          'line' => "#{msg['line']}:#{msg['column']}",
          'rule_id' => msg['ruleId'] }
      end
    end
  end
end
