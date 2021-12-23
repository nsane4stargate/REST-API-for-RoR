FactoryBot.define do
  factory :article do
    title { 'sample-article' }
    content { 'sample-content' }
    sequence(:slug) { |n| "sample-slug-#{n}" }
  end
end
