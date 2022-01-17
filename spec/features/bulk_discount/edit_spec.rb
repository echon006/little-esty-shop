require 'rails_helper'

RSpec.describe 'Bulk discount Edit page' do
  let!(:merch_1) { Merchant.create!(name: 'name_1') }

  let!(:bulk_1) {BulkDiscount.create!(percent: 10, threshold: 2, merchant_id: merch_1.id)}

  it 'has a form page that is auto filled' do
    visit "/merchants/#{merch_1.id}/bulk_discounts/#{bulk_1.id}/edit"
    save_and_open_page

    expect(page).to have_field(:bulk_discount_percent, with: bulk_1.percent)
    expect(page).to have_field(:bulk_discount_threshold, with: bulk_1.threshold)
  end
end
