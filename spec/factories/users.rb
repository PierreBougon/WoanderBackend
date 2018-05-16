FactoryBot.define do
  factory :user do
    login
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
  end
end