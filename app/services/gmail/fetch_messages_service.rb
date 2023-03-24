module Gmail
  class FetchMessagesService < GmailMessagesService
    def message_ids
      @message_ids ||=
        gmail.fetch_all(items: :messages, max: options[:max_records] || 1000) do |token|
          gmail.list_user_messages('me', max_results: 500, page_token: token)
        end.map(&:id)
    end
  end
end
