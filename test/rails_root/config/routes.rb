RiotRails::Application.routes.draw do |map|
  resources :gremlins do
    resources :parties
  end

  match ':controller(/:action(/:id(.:format)))'
end
