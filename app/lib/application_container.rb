# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin
  if Rails.env.test?
    register :git_client, ->(token) { Stubs::GitClientStub.new(token) }
    register :command_runner, -> { Stubs::CommandRunnerStub }
  else
    register :git_client, ->(token) { GitClient.new(token) }
    register :command_runner, -> { Linter::CommandRunner }
  end
end
