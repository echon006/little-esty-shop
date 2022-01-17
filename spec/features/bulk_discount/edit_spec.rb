require 'rails_helper'

RSpec.describe 'Bulk discount Edit page' do
  let!(:merch_1) { Merchant.create!(name: 'name_1') }

  let!(:bulk_1) {BulkDiscount.create!(percent: 10, threshold: 2, merchant_id: merch_1.id)}

  it 'has a form page that is auto filled' do
    visit "/merchants/#{merch_1.id}/bulk_discounts/#{bulk_1.id}/edit"

    expect(page).to have_field(:percent, with: bulk_1.percent)
    expect(page).to have_field(:threshold, with: bulk_1.threshold)
  end

  it "updates/edits the Bulk discount" do
    visit "/merchants/#{merch_1.id}/bulk_discounts/#{bulk_1.id}/edit"

    expect(page).to have_field(:percent, with: bulk_1.percent)
    expect(page).to have_field(:threshold, with: bulk_1.threshold)

    fill_in(:percent, with: 7)
    fill_in(:threshold, with: 9)

    click_button("Update discount")

    expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts/#{bulk_1.id}")

    save_and_open_page
    expect(page).to have_content("Discount percent: 7")
    expect(page).to have_content("Amount needed to recieve discount: 9")
  end
end
