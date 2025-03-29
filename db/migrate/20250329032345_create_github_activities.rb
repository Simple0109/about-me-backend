class CreateGithubActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :github_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :activity_type, null: false
      t.string :github_id, null: false
      t.string :repository_name
      t.string :repository_url
      t.text :description
      t.string :url
      t.datetime :activity_date

      t.timestamps
    end

    add_index :github_activities, :github_id, unique: true
  end
end
