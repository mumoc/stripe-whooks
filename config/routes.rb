StripeTest::Application.routes.draw do
  resources :purchases, only: [:new, :create]
  root to: 'purchases#new'
end
