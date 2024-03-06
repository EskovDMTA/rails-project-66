# frozen_string_literal: true

module Repository
  class CheckPolicy < ApplicationPolicy
    def show?
      user_owns_repository?
    end

    def create?
      user_owns_repository?
    end

    private

    def user_owns_repository?
      record.repository.user == user
    end
  end
end
