module Gmail
  class FetchHistoryService < GmailMessagesService
    def message_ids
      @message_ids ||=
        (
          gmail.list_user_histories(
            'me',
            start_history_id: options[:history_id]
          ).history&.map do |result|
            result.messages_added&.map { |m| m.message.id }
          end || []
        ).compact.flatten
    end
  end
end
