# frozen_string_literal: true

module Repository
  class Check < ApplicationRecord
    include AASM

    belongs_to :repository

    aasm do
      state :pending, initial: true
      state :running, :passed, :failed

      event :run do
        transitions from: :pending, to: :running
      end

      event :pass do
        transitions from: :running, to: :passed
      end

      event :fail do
        transitions from: :running, to: :failed
      end
    end
  end
end
