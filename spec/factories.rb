FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
  	  admin true
    end
  #we can now use FactoryGirl.create(:admin) to create an administrative user in our tests.
  end
end