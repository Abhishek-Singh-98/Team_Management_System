FactoryBot.define do
  factory :employee do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.first_name}
    phone_number {Faker::Alphanumeric.alpha(number: 10)}
    email {Faker::Internet.unique.email}
    experience {rand(1..5)}
    role {"Software_Engineer_2"}
    password {'Pass@123'}
    password_confirmation {'Pass@123'}
  end
end
