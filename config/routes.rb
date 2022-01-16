Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  resources :merchants do
    resources :dashboard, only: [:index]
    resources :items
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: [:update]
    resources :bulk_discounts, only: [:index, :show]
  end

  resources :admin, only: [:index]
  namespace :admin do
    resources :merchants do
    end
    resources :merchants, only: [:index, :show, :edit, :update]
    resources :invoices, only: [:index, :show, :update]
  end
end
