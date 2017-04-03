require 'rails_helper'

RSpec.describe CreatesLocation, :vcr do
  subject { described_class }
  let(:valid_attributes) {
    { title: "The Bean", description: "Technically it's called Cloud Gate", address: "Millennium Park, Chicago" }
  }

  describe "#call" do
    it "saves the record" do
      service = subject.new(valid_attributes)

      expect {
        service.call
      }.to change {
        Location.count
      }.by(1)
    end

    it "is marked as successful" do
      service = subject.new(valid_attributes)
      service.call

      expect(service).to be_success
    end

    it "enqueues a job to send a text message" do
      allow(TextAdminJob).to receive(:perform_later)

      service = subject.new(valid_attributes)
      service.call

      expect(TextAdminJob).to have_received(:perform_later).with(service.location)
    end

    context "with invalid attributes" do
      let(:invalid_attributes) {
        { title: "", description: "There's nothing really here.", address: "Millennium Park, Chicago" }
      }

      it "does not save the record" do
        service = subject.new(invalid_attributes)

        expect {
          service.call
        }.not_to change {
          Location.count
        }
      end

      it "is marked as unsuccessful, and has some errors" do
        service = subject.new(invalid_attributes)

        service.call

        expect(service).not_to be_success
        expect(service.errors).to eq(service.location.errors.full_messages)
      end

      it "doesn't send a text message" do
        allow(TextMessager).to receive(:new)
        service = subject.new(invalid_attributes)

        service.call

        expect(TextMessager).not_to have_received(:new)
      end
    end
  end
end
