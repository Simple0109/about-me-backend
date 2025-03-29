class QiitaArticle < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :qiita_id, presence: true, uniqueness: true
end
