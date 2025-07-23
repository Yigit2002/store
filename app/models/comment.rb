class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5, message: "1 ile 5 arasında bir değer olmalı" }
  validates :user, presence: true
end
