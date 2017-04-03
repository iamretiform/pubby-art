require 'rails_helper'

RSpec.describe SearchesLocations do
  subject(:service) { described_class }

  describe "#call" do
    it "returns all records unedited if there's no query" do
      all_records = double

      result = service.new(query: nil, base: all_records).call

      expect(result).to eq(all_records)
    end

    it "returns a result organized by location otherwise" do
      all_records = Location.all
      allow(all_records).to receive(:near) { [] }

      result = service.new(query: "Eiffel Tower", base: all_records).call

      expect(result).to eq([])
      expect(all_records).to have_received(:near).with("Eiffel Tower")
    end
  end
end
