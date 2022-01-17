require 'rails_helper'

RSpec.describe 'BulkDiscount index page' do

  let!(:merch_1) { Merchant.create!(name: 'name_1') }

  let!(:cust_1) { Customer.create!(first_name: 'fn_1', last_name: 'ln_1') }
  let!(:cust_2) { Customer.create!(first_name: 'fn_2', last_name: 'ln_2') }
  let!(:cust_3) { Customer.create!(first_name: 'fn_3', last_name: 'ln_3') }
  let!(:cust_4) { Customer.create!(first_name: 'fn_4', last_name: 'ln_4') }
  let!(:cust_5) { Customer.create!(first_name: 'fn_5', last_name: 'ln_5') }

  let!(:item_1) { Item.create!(name: 'item_1', description: 'desc_1', unit_price: 1, merchant: merch_1) }
  let!(:item_2) { Item.create!(name: 'item_2', description: 'desc_2', unit_price: 2, merchant: merch_1) }
  let!(:item_3) { Item.create!(name: 'item_3', description: 'desc_3', unit_price: 3, merchant: merch_1) }
  let!(:item_4) { Item.create!(name: 'item_4', description: 'desc_4', unit_price: 4, merchant: merch_1) }
  let!(:item_5) { Item.create!(name: 'item_5', description: 'desc_5', unit_price: 5, merchant: merch_1) }

  let!(:invoice_1) { Invoice.create!(status: 2, customer: cust_1) }
  let!(:invoice_2) { Invoice.create!(status: 2, customer: cust_2) }
  let!(:invoice_3) { Invoice.create!(status: 2, customer: cust_3) }
  let!(:invoice_4) { Invoice.create!(status: 2, customer: cust_4) }
  let!(:invoice_5) { Invoice.create!(status: 2, customer: cust_5) }

  let!(:ii_1) { InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: 1, status: 0) }
  let!(:ii_2) { InvoiceItem.create!(item: item_2, invoice: invoice_2, quantity: 2, unit_price: 2, status: 1) }
  let!(:ii_3) { InvoiceItem.create!(item: item_3, invoice: invoice_3, quantity: 3, unit_price: 3, status: 1) }
  let!(:ii_4) { InvoiceItem.create!(item: item_4, invoice: invoice_4, quantity: 4, unit_price: 4, status: 2) }
  let!(:ii_4) { InvoiceItem.create!(item: item_5, invoice: invoice_5, quantity: 5, unit_price: 4, status: 2) }

  let!(:transactions_1) { Transaction.create!(invoice_id: invoice_1.id, credit_card_number: "4654405418240001", credit_card_expiration_date: "0001", result: 2)}
  let!(:transactions_2) { Transaction.create!(invoice_id: invoice_1.id, credit_card_number: "4654405418240002", credit_card_expiration_date: "0002", result: 2)}
  let!(:transactions_3) { Transaction.create!(invoice_id: invoice_2.id, credit_card_number: "4654405418240003", credit_card_expiration_date: "0003", result: 2)}

  let!(:bulk_1) {BulkDiscount.create!(percent: 10, threshold: 2, merchant_id: merch_1.id)}
  let!(:bulk_2) {BulkDiscount.create!(percent: 15, threshold: 3, merchant_id: merch_1.id)}
  let!(:bulk_3) {BulkDiscount.create!(percent: 20, threshold: 4, merchant_id: merch_1.id)}

  it "shows discounts and threshold to reach discount  " do
    visit merchant_bulk_discounts_path(merch_1)

    expect(page).to have_content(bulk_1.percent)
    expect(page).to have_content(bulk_1.threshold)
    expect(page).to have_content(bulk_2.percent)
    expect(page).to have_content(bulk_3.threshold)
  end

  it "has a link to the bulk discount show page" do
    visit merchant_bulk_discounts_path(merch_1)
    click_on "Discount id: #{bulk_1.id}"
    expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts/#{bulk_1.id}")
  end

  it 'has link to create new discount page (new page with a form to create)' do
    visit merchant_bulk_discounts_path(merch_1)
    click_on "New discount"
    expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts/new")
  end

  it "has a link to delete a bulk discount" do
    visit merchant_bulk_discounts_path(merch_1)
    expect(page).to have_content(bulk_1.percent)
    expect(page).to have_content(bulk_1.threshold)

    click_on "Delete discount #{bulk_1.id}"
    save_and_open_page
    expect(page).not_to have_content(bulk_1.percent)
    expect(page).not_to have_content("Threshold: #{bulk_1.threshold}")

    expect(current_path).to eq(merchant_bulk_discounts_path(merch_1))
  end
end
