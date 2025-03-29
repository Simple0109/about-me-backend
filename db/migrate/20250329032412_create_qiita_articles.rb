class CreateQiitaArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :qiita_articles do |t|
      t.timestamps
    end
  end
end
