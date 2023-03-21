require 'rails_helper'

RSpec.describe Users::PartialSyncEmailService, type: :service do
  describe '.call' do
    let(:user) { FactoryBot.create(:user, messages: [FactoryBot.build(:message, :with_history)]) }

    before do
      allow_any_instance_of(Gmail::FetchHistoryService).to(
        receive(:call).and_yield(gmail_message)
      )
    end

    it 'creates a message' do
      expect { described_class.call(user:, access_token: '') }.to(
        change { user.messages.count }.by(1)
      )
    end
  end
end
