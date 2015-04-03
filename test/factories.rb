# This will guess the User class
FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password  "password"
    password_confirmation "password"
  end

  factory :game do
    association :black_player, factory: :user 
    association :white_player, factory: :user
  end
end