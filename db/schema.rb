# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_03_29_032423) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "github_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "activity_type", null: false
    t.string "github_id", null: false
    t.string "repository_name"
    t.string "repository_url"
    t.text "description"
    t.string "url"
    t.datetime "activity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_github_activities_on_github_id", unique: true
    t.index ["user_id"], name: "index_github_activities_on_user_id"
  end

  create_table "portfolio_projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "image_url"
    t.string "github_url"
    t.string "demo_url"
    t.string "technologies", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portfolio_projects_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "bio"
    t.string "avatar_url"
    t.string "location"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "qiita_articles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "qiita_id", null: false
    t.string "title", null: false
    t.text "body"
    t.string "url"
    t.integer "likes_count"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["qiita_id"], name: "index_qiita_articles_on_qiita_id", unique: true
    t.index ["user_id"], name: "index_qiita_articles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "github_username"
    t.string "qiita_username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "github_activities", "users"
  add_foreign_key "portfolio_projects", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "qiita_articles", "users"
end
