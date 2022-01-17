class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item
  
  enum status: ['pending', 'packaged', 'shipped']

  validates :quantity, presence: true
  validates :unit_price, presence: true


end
