map.namespace :admin do |admin|
   admin.resources :products do |product|
     product.resources :price_variations, :member => {:select => :post, :remove => :post}, :collection => {:available => :post, :selected => :get}
   end
end