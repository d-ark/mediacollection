FactoryGirl.define do
  factory :alice, class: User do
    email 'alice@example.com'
    password 'secret'
    password_confirmation 'secret'
  end

  factory :bob, class: User do
    email 'bob@example.com'
    password 'super_secret'
    password_confirmation 'super_secret'
  end

end
