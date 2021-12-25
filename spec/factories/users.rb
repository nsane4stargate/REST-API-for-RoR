FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "jsmith-#{n}@api.com" }
    name { 'Jane Smith' }
    url { 'http://example.com' }
    avatar_url { 'http://example.com/avatar' }
    provider { 'GITHUB' }
  end
end
