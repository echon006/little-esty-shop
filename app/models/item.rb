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

end
