FactoryBot.define do
  factory :users do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password Faker::Internet.password
  end
end