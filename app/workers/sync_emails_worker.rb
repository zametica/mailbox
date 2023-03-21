class SyncEmailsWorker
  include Sidekiq::Worker

  def perform(access_token)
    Users::ImportEmailsService.call(access_token:)
  rescue UnrecoverableError => e
    p e.message
    # skip retry
  end
end
