class Address < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true
  validates :city, presence: true
  validates :country, presence: true
end
