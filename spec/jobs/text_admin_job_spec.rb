require 'rails_helper'

RSpec.describe TextAdminJob do
  subject { described_class }
  let(:location) { Location.new }

  describe "#perform" do
    it "sends a text message" do
      messager = double(send: true)
      allow(TextMessager).to receive(:new) { messager }

      subject.perform_now(location)

      expect(TextMessager).to have_received(:new)
      expect(messager).to have_received(:send)
    end
  end
end