FactoryBot.define do
  factory :github_activity do
    user
    sequence(:github_id) { |n| "gh-#{n}" }
    activity_type { %w[Repository Commit PullRequest].sample }
    repository_name { Faker::App.name.parameterize }
    repository_url { "https://github.com/#{Faker::Internet.username}/#{repository_name}" }
    description { Faker::Lorem.sentence }
    url { repository_url }
    activity_date { Faker::Time.between(from: 1.year.ago, to: Time.current) }

    trait :repository do
      activity_type { "Repository" }
    end

    trait :commit do
      activity_type { "Commit" }
    end
  end
end
