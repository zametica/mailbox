require 'rails_helper'

RSpec.describe Users::ImportEmailsService, type: :service do
  describe '.call' do
    context 'when import is successful' do
      context 'when first time sync' do
        let(:user) { FactoryBot.create(:user) }

        it 'performes a full sync' do
          expect(Users::FullSyncEmailService).to receive(:call)

          expect { described_class.call(user_id: user.id) }.not_to raise_error
        end
      end

      context 'when sync has been already performed' do
        let(:user) { FactoryBot.create(:user, messages: [FactoryBot.build(:message, :with_history)]) }

        it 'performes a partial sync' do
          expect(Users::PartialSyncEmailService).to receive(:call)

          expect { described_class.call(user_id: user.id) }.not_to raise_error
        end
      end
    end

    context 'when user is missing' do
      it 'raises unrecoverable error' do
        expect { described_class.call(user_id: nil) }.to(
          raise_error(UnrecoverableError)
        )
      end
    end

    context 'when authorization fails' do
      let(:user) { FactoryBot.create(:user) }

      before do
        allow(Users::FullSyncEmailService).to receive(:call).and_raise(Signet::AuthorizationError)
      end

      it 'raises unrecoverable error' do
        expect { described_class.call(user_id: nil) }.to(
          raise_error(UnrecoverableError)
        )
      end
    end
  end
end
