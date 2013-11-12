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

  factory :micropost do
    content "Lorem ipsum"
    user
  end
  #Here we tell Factory Girl about the micropost’s associated user just by including a user 
  #in the definition of the factory.
end