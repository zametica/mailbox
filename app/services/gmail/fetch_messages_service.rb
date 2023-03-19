module Gmail
  class FetchMessagesService < GmailService
    def call(&callback)
      message_ids.each_slice(100) do |ids_batch|
        gmail.batch do |gm|
          ids_batch.each do |id|
            gm.get_user_message('me', id, &callback)
          end
        end
      end
    end

    private

    def message_ids
      @message_ids ||=
        gmail.fetch_all(items: :messages, max: options[:max_records] || 1000) do |token|
          gmail.list_user_messages('me', max_results: 500, page_token: token)
        end.map(&:id)
    end
  end
end
