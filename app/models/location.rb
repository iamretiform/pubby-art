class Location < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  geocoded_by :address
  after_validation :geocode
end
