class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository
  include AASM

  aasm do
    state :pending, initial: true
    state :lint_running, :complete, :error

    event :start_check do
      transitions from: :pending, to: :eslint_running
    end

    event :complete_eslint do
      transitions from: :eslint_running, to: :eslint_complete
    end

    event :handle_error do
      transitions to: :error
    end

  end

end
