Rails.application.routes.draw do

  resources :merchants do
    resources :dashboards, only: [:index]
    resources :items do
      patch 'status_change'
    end
    resources :invoices, only: [:index, :show]
  end

  resources :transactions
  resources :customers
end
