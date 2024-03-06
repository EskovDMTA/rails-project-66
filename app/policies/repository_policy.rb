# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user == record.user
  end

  def new?
    user
  end

  def create?
    new?
  end

  private

  def user_owns_repository?
    record.repository.user == user
  end
end
