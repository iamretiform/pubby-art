require 'rails_helper'

RSpec.describe TextMessager do
  subject { described_class }
  let(:recipient) { '8005551212' }
  let(:sender) { '8005551313' }
  let(:message) { 'ahoihoi' }

  it "raises an error if you don't provide a recipient or message" do
    expect { subject.new(recipient: recipient) }.to raise_error(ArgumentError)

    expect { subject.new(message: message) }.to raise_error(ArgumentError)

    expect { subject.new(recipient: recipient, message: message) }.not_to raise_error
  end

  it "saves the configuration you pass in" do
    messager = subject.new(recipient: recipient, message: message)

    expect(messager.recipient).to eq(recipient)
    expect(messager.message).to eq(message)
  end

  it "creates a message when requested" do
    messages = double(create: "yay")
    allow(Twilio::REST::Client).to receive(:new).and_return(double(messages: messages))

    messager = subject.new(recipient: recipient, message: message, from: sender)
    response = messager.send

    expect(messages).to have_received(:create).with(from: sender, to: recipient, body: message)
    expect(response).to eq("yay")
  end
end
