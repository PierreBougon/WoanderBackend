FactoryBot.define do
  factory :posts do
    user
    description Faker::Lorem.sentence
    media_type Faker::Lorem.word
    coordinates "#{Faker::Address.latitude},#{Faker::Address.longitude}"
    content Faker::Lorem.paragraph
  end
end