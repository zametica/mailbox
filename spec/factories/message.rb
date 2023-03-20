FactoryBot.define do
  factory :message do
    user

    message_id { SecureRandom.uuid }
    subject { 'Test mail' }
    sender { 'test@example.com' }
    recipient { 'recipient@example.com' }

    trait :with_history do
      history_id { '12345678' }
    end
  end
end
