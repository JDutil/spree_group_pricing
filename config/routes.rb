Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products do
      resources :variants do
        resources :group_prices
      end
    end
  end
end
