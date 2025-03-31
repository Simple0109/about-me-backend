class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy
  has_many :github_activities, dependent: :destroy
  has_many :qiita_articles, dependent: :destroy
  has_many :portfolio_projects, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  def generate_token
    Auth.encode(user_id: id)
  end
end
