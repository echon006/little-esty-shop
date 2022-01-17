class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(percent: params[:percent], threshold: params[:threshold])
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk = BulkDiscount.find(params[:id])
    @bulk.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk = @merchant.bulk_discounts.find(params[:id])
    @bulk.update!(percent: params[:percent], threshold: params[:threshold])
    @bulk.save
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk.id}"
  end
end
