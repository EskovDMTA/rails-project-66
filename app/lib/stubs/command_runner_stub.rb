# frozen_string_literal: true

class CommandRunnerStub
  def self.run(command, chdir: nil)
    { stdout: '', stderr:, exit_status: 0 }
  end
end
