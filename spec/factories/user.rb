FactoryBot.define do
  factory :user do
    name {"test user #{Time.now.to_s }" }
    sequence :user_id do |n|
    	n
  	end
  end
end