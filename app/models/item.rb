class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts, through: :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def best_day
    invoices.joins(:transactions)
            .where(transactions: { result: 2 })
            .select('invoices.created_at, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
            .group(:created_at)
            .order(revenue: :desc)
            .first
            .created_at.strftime("%B %d, %Y")
  end

  def best_discount_for_item(quantity)
    bulk_discounts.where('? >= bulk_discounts.threshold', quantity)
                  .order(percent: :desc).first
  end

  # def best_discount_for_item
  #   require "pry"; binding.pry
  #    item.bulk_discounts
  #        .where('invoice_items.quantity >= bulk_discounts.threshold')
  #        # .select('bulk_discounts.id, invoice_items.id, max(bulk_discounts.percent)')
  #        # .group('bulk_discounts.id,  invoice_items.id')
  # end

end
