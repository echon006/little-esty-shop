class Customer < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :transactions, through: :invoices
  has_many :bulk_discounts, through: :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true

  # Class Methods
  def self.top_customers
    joins(:transactions).where('transactions.result = ?', 2)
                        .select('customers.*, count(transactions)')
                        .group('customers.id')
                        .order(count: :desc)
                        .limit(5)
  end

  # Instance Methods
  def full_name
    first_name + ' ' + last_name
  end

  def purchase_count
    transactions.where('transactions.result = ?', 2).count(:transactions)
  end

end
