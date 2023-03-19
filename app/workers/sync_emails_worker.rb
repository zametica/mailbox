class SyncEmailsWorker
  include Sidekiq::Worker

  def perform(user_id)
    Users::ImportEmailsService.call(user_id:)
  rescue UnrecoverableError
    # skip retry
  end
end
