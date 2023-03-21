require 'rails_helper'

RSpec.describe Users::ImportEmailsService, type: :service do
  describe '.call' do
    let(:access_token) { 'TEST_TOKEN' }

    context 'when import is successful' do
      context 'when first time sync' do
        let(:user) { FactoryBot.create(:user) }
        before do
          allow(Gmail::VerifyTokenService).to receive(:call)
            .and_return(OpenStruct.new(email: user.email))
        end

        it 'performes a full sync' do
          expect(Users::FullSyncEmailService).to receive(:call)

          expect { described_class.call(access_token:) }.not_to raise_error
        end
      end

      context 'when sync has been already performed' do
        let(:user) { FactoryBot.create(:user, messages: [FactoryBot.build(:message, :with_history)]) }
        before do
          allow(Gmail::VerifyTokenService).to receive(:call)
            .and_return(OpenStruct.new(email: user.email))
        end

        it 'performes a partial sync' do
          expect(Users::PartialSyncEmailService).to receive(:call)

          expect { described_class.call(access_token:) }.not_to raise_error
        end
      end
    end

    context 'when user is missing' do
      before do
        allow(Gmail::VerifyTokenService).to receive(:call)
          .and_return(OpenStruct.new(email: 'unknown@example.com'))
      end

      it 'raises unrecoverable error' do
        expect { described_class.call(access_token: nil) }.to(
          raise_error(UnrecoverableError)
        )
      end
    end

    context 'when authorization fails' do
      before do
        allow(Gmail::VerifyTokenService).to receive(:call)
          .and_raise(Google::Apis::Error.new(StandardError.new('fail')))
      end

      it 'raises unrecoverable error' do
        expect { described_class.call(access_token: '') }.to(
          raise_error(UnrecoverableError)
        )
      end
    end
  end
end
