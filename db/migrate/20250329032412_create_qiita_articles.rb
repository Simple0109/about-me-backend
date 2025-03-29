class CreateQiitaArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :qiita_articles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :qiita_id, null: false
      t.string :title, null: false
      t.text :body
      t.string :url
      t.integer :likes_count
      t.datetime :published_at

      t.timestamps
    end

    add_index :qiita_articles, :qiita_id, unique: true
  end
end
