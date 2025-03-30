FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    github_username { Faker::Internet.unique.username }
    qiita_username { Faker::Internet.unique.username }
  end
end
