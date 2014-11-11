FactoryGirl.define do
  factory :user do
    login "test_user"
    github_id 123456
    url 'https://github_test.com/'
    avatar_url 'https://github_test.com/'
  end
end
