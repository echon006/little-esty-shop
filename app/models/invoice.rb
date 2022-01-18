class Invoice < ApplicationRecord
  include ApplicationHelper
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :invoice_items

  enum status: ['in progress', 'cancelled', 'completed']

  # Class Methods
  def self.incomplete_list
    joins(:invoice_items).where('invoice_items.status != ?', 2).select('invoices.*').group('invoices.id')
  end

  def self.order_created_at
    order('invoices.created_at')
  end

  # Instance Methods
  def created_at_formatted
    created_at.strftime("%A, %B %-d, %Y")
  end

  def customer_full_name
    self.customer.first_name + ' ' + self.customer.last_name
  end

  def items_ready_ship
    invoice_items.where('invoice_items.status = ?', 1)
  end

  def total_revenue
    cents_to_dollars(invoice_items.sum('unit_price * quantity'))
  end

  def discounted_amount
    (invoice_items.joins(:bulk_discounts)
                  .where('invoice_items.quantity >= bulk_discounts.threshold')
                  .select('invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent / 100.0)) as best_discount')
                  .group('invoice_items.id')
                  .sum(&:best_discount))
  end

  def total_revenue_as_integer
    (invoice_items.sum('unit_price * quantity'))
  end

  def discounted_revenue
    cents_to_dollars(total_revenue_as_integer - discounted_amount)
  end

end
