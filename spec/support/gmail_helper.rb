module GmailHelper
  def gmail_message
    json = {
      id: SecureRandom.uuid,
      history_id: 12345678,
      thread_id: SecureRandom.uuid,
      internal_date: 1679305601000,
      payload: {
        body: {
          data: 'Hello'
        },
        headers: [
          { name: 'Subject', value: 'Test' },
          { name: 'From', value: 'from@example.com' },
          { name: 'Delivered-To', value: 'delivered-to@example.com' }
        ]
      }
    }.to_json

    JSON.parse(json, object_class: OpenStruct)
  end
end
