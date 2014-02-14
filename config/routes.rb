Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :products do
      resources :variants do
        resources :group_prices
      end
    end
  end
end
