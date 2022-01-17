require 'rails_helper'

RSpec.describe 'Bulk discount New page' do
  let!(:merch_1) { Merchant.create!(name: 'name_1') }

  let!(:bulk_1) {BulkDiscount.create!(percent: 10, threshold: 2, merchant_id: merch_1.id)}
  let!(:bulk_2) {BulkDiscount.create!(percent: 15, threshold: 3, merchant_id: merch_1.id)}

  it 'has a form to create a new discount' do
    visit "/merchants/#{merch_1.id}/bulk_discounts/new"
    fill_in("Percent", with: 20)
    fill_in("Threshold", with: 4)
    click_button "Submit"
    expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts")
    expect(page).to have_content("Discount Percent: 20")
    expect(page).to have_content("Threshold: 4")
  end
end
