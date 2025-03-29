class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :bio
      t.string :avatar_url
      t.string :location
      t.string :website

      t.timestamps
    end
  end
end
