module MessageParser
  def parse(message)
    {
      message_id: message.id,
      history_id: message.history_id,
      thread_id: message.thread_id,
      subject: header(message, 'Subject'),
      sender: header(message, 'From'),
      recipient: header(message, 'Delivered-To'),
      body: body(message),
      sent_at: Time.at(message.internal_date / 1000)
    }
  end

  def header(message, name)
    message.payload.headers.find { |h| h.name == name }&.value
  end

  def body(message)
    return message.payload.body.data if message.payload.body.present?
    return '' if message.payload.parts.blank?

    message.payload.parts.map(&:body).map(&:data).join(' ')
  end
end
