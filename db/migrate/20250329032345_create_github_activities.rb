class CreateGithubActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :github_activities do |t|
      t.timestamps
    end
  end
end
