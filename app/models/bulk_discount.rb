class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percent, presence: true
  validates :merchant_id, presence: true
end
