FactoryBot.define do
  factory :post do
    user
    description Faker::Lorem.paragraph
    media_type Faker::Lorem.word
    coordinates "#{Faker::Address.latitude}:#{Faker::Address.longitude}"
    media_link Faker::Lorem.sentence
  end
end