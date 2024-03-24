# frozen_string_literal: true

class Repository
  class Check < ApplicationRecord
    include AASM

    belongs_to :repository

    aasm do
      state :pending, initial: true
      state :running, :finished, :failed

      event :run do
        transitions from: :pending, to: :running
      end

      event :finish do
        transitions from: :running, to: :finished
      end

      event :fail do
        transitions from: :running, to: :failed
      end
    end
  end
end
