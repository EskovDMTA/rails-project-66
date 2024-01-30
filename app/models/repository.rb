class Repository < ApplicationRecord
  include Enumerize

  belongs_to :user
  has_many :checks, class_name: "Repository::Check", dependent: :destroy

  validates :name, :language, :full_name, :git_url, :ssh_url, presence: true
  enumerize :language, in: %w[JavaScript Ruby]
end
