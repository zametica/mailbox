require 'rails_helper'

RSpec.describe Users::FullSyncEmailService, type: :service do
  describe '.call' do
    let(:user) { FactoryBot.create(:user) }

    before do
      allow_any_instance_of(Gmail::FetchMessagesService).to(
        receive(:call).and_yield(gmail_message, nil)
      )
    end

    it 'creates a message' do
      expect { described_class.call(user:, access_token: '') }.to(
        change { user.messages.count }.by(1)
      )
    end
  end
end
