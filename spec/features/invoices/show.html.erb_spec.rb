require 'rails_helper'

RSpec.describe 'merchant invoice show page', type: :feature do
  let!(:merch_1) { create(:merchant) }
  let!(:item_1) { create(:item, merchant: merch_1) }
  let!(:item_2) { create(:item, merchant: merch_1) }
  let!(:item_3) { create(:item, merchant: merch_1) }
  let!(:invoice_1) { create(:invoice) }
  let!(:invoice_item_1) { create(:invoice_item, item: item_1, invoice: invoice_1) }
  let!(:invoice_item_2) { create(:invoice_item, item: item_2, invoice: invoice_1) }
  let!(:invoice_item_3) { create(:invoice_item, item: item_3, invoice: invoice_1) }

  let!(:merch_2) { create(:merchant) }
  let!(:item_4) { create(:item, merchant: merch_2) }
  let!(:item_5) { create(:item, merchant: merch_2) }
  let!(:item_6) { create(:item, merchant: merch_2) }
  let!(:invoice_2) { create(:invoice) }
  let!(:invoice_item_4) { create(:invoice_item, item: item_4, invoice: invoice_2) }
  let!(:invoice_item_5) { create(:invoice_item, item: item_5, invoice: invoice_2) }
  let!(:invoice_item_6) { create(:invoice_item, item: item_6, invoice: invoice_2) }

  let!(:bulk_1) {BulkDiscount.create!(percent: 10, threshold: 2, merchant_id: merch_1.id)}
  let!(:bulk_2) {BulkDiscount.create!(percent: 15, threshold: 3, merchant_id: merch_1.id)}

  before(:each) { visit merchant_invoice_path(merch_1, invoice_1) }

  describe 'as a merchant' do
    describe 'views elements on the page' do
      it 'displays invoice info, id, status, created date, and customer name' do
        expect(page).to have_content("Invoice ##{invoice_1.id}")
        expect(page).to have_content("Status: #{invoice_1.status}")
        expect(page).to have_content("Created On: #{invoice_1.created_at_formatted}")
        expect(page).to have_content(invoice_1.customer_full_name)
      end

      it 'displays invoice items info, name, quantity, and unit price' do
        within("#item-#{item_1.id}") do

          expect(page).to have_content(item_1.name)
          expect(page).to have_content(invoice_item_1.quantity)
          expect(page).to have_content(invoice_item_1.unit_price)
        end

        within("#item-#{item_2.id}") do
          expect(page).to have_content(item_2.name)
          expect(page).to have_content(invoice_item_2.quantity)
          expect(page).to have_content(invoice_item_2.unit_price)
        end

        within("#item-#{item_3.id}") do
          expect(page).to have_content(item_3.name)
          expect(page).to have_content(invoice_item_3.quantity)
          expect(page).to have_content(invoice_item_3.unit_price)
        end
      end

      it 'does not display invoice items from other merchants' do
        within('table') do
          expect(page).to have_no_content(item_4.name)

          expect(page).to have_no_content(item_5.name)

          expect(page).to have_no_content(item_6.name)

        end
      end

      it 'displays total revenue for the invoice' do
        expect(page).to have_content("Total Revenue: #{invoice_1.total_revenue}")
      end

      it 'displays a status dropdown and update button' do
        within("#item-#{item_1.id}") do
          expect(page).to have_select('invoice_item_status', options: ['pending', 'packaged', 'shipped'], selected: 'pending')

          expect(page).to have_button('Update Item Status')
        end

        within("#item-#{item_2.id}") do
          expect(page).to have_select('invoice_item_status', options: ['pending', 'packaged', 'shipped'], selected: 'pending')

          expect(page).to have_button('Update Item Status')
        end

        within("#item-#{item_3.id}") do
          expect(page).to have_select('invoice_item_status', options: ['pending', 'packaged', 'shipped'], selected: 'pending')

          expect(page).to have_button('Update Item Status')
        end
      end
    end

    describe 'clickable elements' do
      it 'updates the invoice items status' do
        within("#item-#{item_1.id}") do
          select('packaged', from: 'invoice_item_status')
          click_button('Update Item Status')

          expect(page).to have_select('invoice_item_status', selected: 'packaged')
        end

        expect(page).to have_current_path(merchant_invoice_path(merch_1, invoice_1))

        within("#item-#{item_2.id}") do
          select('pending', from: 'invoice_item_status')
          click_button('Update Item Status')

          expect(page).to have_select('invoice_item_status', selected: 'pending')
        end

        expect(page).to have_current_path(merchant_invoice_path(merch_1, invoice_1))

        within("#item-#{item_3.id}") do
          select('shipped', from: 'invoice_item_status')
          click_button('Update Item Status')

          expect(page).to have_select('invoice_item_status', selected: 'shipped')
        end

        expect(page).to have_current_path(merchant_invoice_path(merch_1, invoice_1))
      end

      describe 'discounted revenue' do
        it "shows a discounted revenue" do
          expect(page).to have_content("Discounted Revenue: #{invoice_1.discounted_revenue}")
        end
      end

      it "has a link to the discount applied show page" do

        merch_10 = Merchant.create!(name: 'Merch 1')

        item_10 = Item.create!(name: "Item 1", description: "Description 1", unit_price: 10, merchant_id: merch_10.id)
        item_20 = Item.create!(name: "Item 2", description: "Description 2", unit_price: 8, merchant_id: merch_10.id)

        customer_10 = Customer.create!(first_name: 'Cust first 1', last_name: 'Cust last 1')
        invoice_10 = Invoice.create!(customer_id: customer_10.id, status: 2)
        ii_10 = InvoiceItem.create!(invoice_id: invoice_10.id, item_id: item_10.id, quantity: 100, unit_price: 10, status: 1)
        # ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 500, unit_price: 10, status: 2)

        transaction_10 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_10.id)

        bulk_10 = merch_10.bulk_discounts.create!(percent: 10, threshold: 10)
        bulk_20 = merch_10.bulk_discounts.create!(percent: 15, threshold: 80)
        bulk_30 = merch_10.bulk_discounts.create!(percent: 20, threshold: 110)

        visit "/merchants/#{merch_10.id}/invoices/#{invoice_10.id}"

        expect(ii_10.item.best_discount_for_item(ii_10.quantity).id).to eq(bulk_20.id)
        click_link("Discount id: #{bulk_20.id}")
        expect(current_path).to eq("/merchants/#{merch_10.id}/bulk_discounts/#{bulk_20.id}")
      end
    end
  end
end
