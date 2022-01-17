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
end
