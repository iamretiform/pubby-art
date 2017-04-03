class TextMessager
  attr_reader :recipient, :message, :from

  def initialize(recipient:, message:, from: Rails.application.secrets.twilio_phone)
    @recipient = recipient
    @message = message
    @from = from
  end

  def send
    client = Twilio::REST::Client.new
    client.messages.create({
      from: from,
      to: recipient,
      body: message,
    })
  end
end
