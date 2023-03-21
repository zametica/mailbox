module Api
  class MailsController < ApiController
    def index
      render json: {
        items: messages,
        total_count: messages.total_count
      }
    end

    private

    def search_params
      params.permit(:q, :from_date, :to_date, :page, :per_page)
    end

    def messages
      @messages ||=
        Message.where(user:)
               .search(search_params)
               .order(sent_at: :desc)
               .page(search_params[:page] || 1)
               .per(search_params[:per_page] || 50)
    end
  end
end
