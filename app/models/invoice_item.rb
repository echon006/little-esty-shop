class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  enum status: ['pending', 'packaged', 'shipped']

  validates :quantity, presence: true
  validates :unit_price, presence: true


  # def discount_items
  #   item.joins(invoice: :bulk_discounts)
  #       .where('invoice_items.quantity >= bulk_discounts.threshold')
  #       .select('bulk_discounts.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent / 100.0)) as best_discount')
  #       .group('bulk_discounts.id')
  # end
end
