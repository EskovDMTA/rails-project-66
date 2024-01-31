module Linter
  class RubyLinter < BaseLinter
    def lint(repo_path)
      @repo_path = repo_path
      rubocop_command = "bundle exec rubocop --safe --format json #{create_config}"
      stdout, exit_status = run_command(rubocop_command)
      build_parsing_result(stdout, exit_status)
    end

    private

    def parsing_result(linter_result)
      json_result = JSON.parse(linter_result, symbolize_names: true)
      filter_empty_offenses = json_result[:files].reject { |element| element[:offenses].empty? }
      json_result[:files] = filter_empty_offenses
      json_result
    end

    def run_command(command)
      Dir.chdir(Rails.root.join(@repo_path)) do
        stdout, exit_status = Open3.capture2e(command)
        [stdout, exit_status]
      end
    end

    def create_config
      default_config = "#{Rails.root}/.rubocop.yml"
      repository_config = "#{Rails.root.join(@repo_path)}/.rubocop.yml"
      FileUtils.cp(default_config, repository_config.to_s)
      "-c #{repository_config}"
    end

  end
end
