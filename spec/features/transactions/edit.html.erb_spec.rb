require 'rails_helper'

RSpec.describe "transactions/edit", type: :view do
  before(:each) do
    @transaction = assign(:transaction, Transaction.create!(
      invoices: nil,
      credit_card_number: 1,
      result: 1
    ))
  end

end
