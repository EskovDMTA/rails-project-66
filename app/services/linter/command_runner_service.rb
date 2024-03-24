# frozen_string_literal: true

module Linter
  module CommandRunnerService
    def self.run(command, chdir: nil)
      if chdir.nil?
        stdout, stderr, status = Open3.capture3(command)
      else
        stdout, stderr, status = Dir.chdir(chdir.to_s) do
          Open3.capture3(command)
        end
      end
      { stdout:, stderr:, exit_status: status.exitstatus }
    end
  end
end
