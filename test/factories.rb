FactoryGirl.define do 
	factory :user do
		sequence :email do |n|
			"email#{n}@gmail.com"
		end
		password "omgomgomg"
		password_confirmation "omgomgomg"
	end 

	factory :game do
		association :user
	end
end