module FilterMessages
  extend ActiveSupport::Concern

  included do
    scope :search, lambda { |params|
      by_from_date(params[:from_date])
        .by_to_date(params[:to_date])
        .by_q(params[:q])
    }

    scope :by_from_date, lambda { |from_date|
      where('sent_at >= ?', from_date) if from_date.present?
    }

    scope :by_to_date, lambda { |to_date|
      where('sent_at < ?', to_date) if to_date.present?
    }

    scope :by_q, lambda { |q|
      where('sender ILIKE :q OR subject ILIKE :q', q: "%#{q}%") if q.present?
    }
  end
end
