Stripe.api_key = ENV['STRIPE_API_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

StripeEvent.subscribe 'charge.succeeded' do |event|
  ReceiptMailer.send_receipt(event.data.object).deliver
end
