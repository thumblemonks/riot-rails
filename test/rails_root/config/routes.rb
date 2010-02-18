RiotRails::Application.routes.draw do |map|
  resources :gremlins
  match ':controller(/:action(/:id(.:format)))'
end
