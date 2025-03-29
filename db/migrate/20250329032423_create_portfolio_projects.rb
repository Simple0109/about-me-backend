class CreatePortfolioProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :portfolio_projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.string :image_url
      t.string :github_url
      t.string :demo_url
      t.string :technologies, array: true, default: []

      t.timestamps
    end
  end
end
