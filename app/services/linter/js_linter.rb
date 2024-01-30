module Linter
  class JsLinter < BaseLinter
    def lint(repo_path)
      eslint_command = "yarn eslint #{repo_path}"
      # eslint_command = "yarn eslint --format json #{repo_path}"
      stdout, exit_status = run_command(eslint_command)
      puts stdout
      build_parsing_result(stdout, exit_status)
    end

    private

    def extract_errors_blocks(lint_errors)
      lint_errors.split("\n\n").map { |errors_block| errors_block.split("\n") }
    end

    def strip_error_lines(lint_errors)
      lint_errors.map! { |element| element.map(&:strip) }
    end

    def parse_file_errors(file_errors)
      file_path = file_errors[0]
      errors = file_errors[1..-1].map { |error_line| parse_error_line(error_line) }
      { file: file_path, errors: errors }
    end

    def parse_error_line(error_line)
      parts = error_line.split(/\s{2,}/)
      line_number = parts[0]
      error_type = parts[1]
      error_description = parts[2]
      error_code = parts[3..-1].join(' ')
      { line: line_number, type: error_type, description: error_description, code: error_code }
    end

    def parsing_result(lint_errors)
      lint_result = strip_error_lines(extract_errors_blocks(lint_errors))
      lint_result[1..-3].map { |file_errors| parse_file_errors(file_errors) }
    end

  end
end
