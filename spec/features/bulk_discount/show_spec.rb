require 'rails_helper'

RSpec.describe 'Bulk discount Show page' do
  let!(:merch_1) { Merchant.create!(name: 'name_1') }

  let!(:bulk_1) {BulkDiscount.create!(percent: 10, threshold: 2, merchant_id: merch_1.id)}
  let!(:bulk_2) {BulkDiscount.create!(percent: 15, threshold: 3, merchant_id: merch_1.id)}

  it "shows the discount percentages and threshold" do
    visit "/merchants/#{merch_1.id}/bulk_discounts/#{bulk_1.id}"

    expect(page).to have_content(bulk_1.percent)
    expect(page).to have_content(bulk_1.threshold)
  end
end
