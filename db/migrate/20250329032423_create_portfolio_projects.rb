class CreatePortfolioProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :portfolio_projects do |t|
      t.timestamps
    end
  end
end
