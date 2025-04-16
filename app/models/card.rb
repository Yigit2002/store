class Card < ApplicationRecord
  belongs_to :user
  validates :name, :number, :security_code, :expiry_date, presence: true
  validates :number, uniqueness: true, length: { is: 16 }
  validates :security_code, length: { is: 3 }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  after_initialize :set_default_balance, if: :new_record?

  private

  def set_default_balance
    self.balance ||= 0
  end
end