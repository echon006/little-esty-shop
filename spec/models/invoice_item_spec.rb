require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_many(:bulk_discounts).through(:item) }
  end

  describe 'validations' do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it { should define_enum_for(:status).with(['pending', 'packaged', 'shipped']) }
  end

  # it "checks for the discount applied to each item" do
  #   merch_1 = Merchant.create!(name: 'Merch 1')
  #
  #   item_1 = Item.create!(name: "Item 1", description: "Description 1", unit_price: 10, merchant_id: merch_1.id)
  #   item_2 = Item.create!(name: "Item 2", description: "Description 2", unit_price: 8, merchant_id: merch_1.id)
  #
  #   customer_1 = Customer.create!(first_name: 'Cust first 1', last_name: 'Cust last 1')
  #   invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2)
  #   ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 100, unit_price: 10, status: 1)
  #   # ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 500, unit_price: 10, status: 2)
  #
  #   transaction_1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
  #
  #   bulk_1 = BulkDiscount.create!(percent: 10, threshold: 10, merchant_id: merch_1.id)
  #   bulk_2 = BulkDiscount.create!(percent: 15, threshold: 80, merchant_id: merch_1.id)
  #   bulk_3 = BulkDiscount.create!(percent: 20, threshold: 110, merchant_id: merch_1.id)
  #
  #   expect(ii_1.discount_items).to eq(bulk_2)
  # end
end
