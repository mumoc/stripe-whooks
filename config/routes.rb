StripeTest::Application.routes.draw do
  resources :purchases, only: [:new, :create]
  mount StripeEvent::Engine => '/stripe-webhooks'

  root to: 'purchases#new'
end
