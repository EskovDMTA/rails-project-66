# frozen_string_literal: true

module Stubs
  class CommandRunnerServiceStub
    # rubocop:disable Lint/UnusedMethodArgument
    def self.run(_command, chdir: nil)
      { stdout: '', stderr:, exit_status: 0 }
    end

    # rubocop:enable Lint/UnusedMethodArgument
  end
end
