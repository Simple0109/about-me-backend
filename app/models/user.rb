class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :github_activities, dependent: :destroy
  has_many :qiita_articles, dependent: :destroy
  has_many :portfolio_projects, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
