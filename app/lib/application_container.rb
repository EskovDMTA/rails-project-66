# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin
  if Rails.env.test?
    register :git_client, ->(token) { Stubs::GitClientServiceStub.new(token) }
    register :command_runner, -> { Stubs::CommandRunnerServiceStub }
  else
    register :git_client, ->(token) { GitClientService.new(token) }
    register :command_runner, -> { Linter::CommandRunnerService }
  end
end
