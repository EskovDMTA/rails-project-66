# frozen_string_literal: true

module Linter
  class LinterFactory
    def self.create_linter(language)
      case language.downcase
      when 'javascript'
        JsLinter.new
      when 'ruby'
        RubyLinter.new
      else
        raise ArgumentError, "Unsupported language: #{language}"
      end
    end
  end
end
