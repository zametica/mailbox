FactoryBot.define do
  factory :user do
    access_token { 'TEST' }
    refresh_token { 'TEST' }

    email { "#{SecureRandom.uuid}@test.com" }
  end
end
