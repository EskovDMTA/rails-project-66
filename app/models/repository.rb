# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  validates :name, :language, :full_name, :git_url, :ssh_url, presence: true
  enumerize :language, in: %w[javascript ruby]
end
