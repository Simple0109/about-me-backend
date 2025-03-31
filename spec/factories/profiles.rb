FactoryBot.define do
  factory :profile do
    user
    name { Faker::Name.name }
    bio { Faker::Lorem.paragraph }
    avatar_url { Faker::Internet.url }
    location { Faker::Address.city }
    website { Faker::Internet.url }
  end
end
