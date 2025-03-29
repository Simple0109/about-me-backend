class GithubActivity < ApplicationRecord
  belongs_to :user

  validates :activity_type, presence: true
  validates :github_id, presence: true, uniqueness: true
end
