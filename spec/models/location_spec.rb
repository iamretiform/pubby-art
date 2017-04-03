require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "geocoding", :vcr do
    it "geocodes the model on save" do
      location = Location.new(address: "Eiffel Tower", title: "The Eiffel Tower, obv.", description: "...")

      expect {
        location.save
      }.to change {
        [location.latitude, location.longitude]
      }
    end
  end
end
