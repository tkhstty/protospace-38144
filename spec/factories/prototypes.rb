FactoryBot.define do
  factory :prototype do
    title {Faker::App.name}
    catch_copy {Faker::Lorem.sentence}
    concept {Faker::Lorem.sentence}
    association :user

    after(:build) do |prototype|
      prototype.image.attach(io: File.open('public/images/test_image1.png'), filename: 'test_image1.png')
    end
  end
end
