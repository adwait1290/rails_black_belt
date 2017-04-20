FactoryGirl.define do
  factory :borrower do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    password ""
    money 1
    purpose "MyString"
    description "MyText"
    raised 1
  end
end
