class PurchasesService
  attr_accessor :card, :shipping_address

  def initialize card_data
    @card = card_data
    @shipping_address = shipping
  end

  def charge
    begin
      charge = Stripe::Charge.create(
        amount: 100000,
        currency: 'usd',
        card: card[:stripeToken],
        description: 'Ardusat Kit',
        metadata: {
          shipping_address: shipping_address
        }
      )
      { charge: charge }
    rescue Stripe::CardError => e
      { error: e.message }
    end
  end

  private
  def shipping
    billing = address_string card[:billing_address]
    shipping = address_string card[:shipping_address]
    shipping || billing
  end

  def address_string address
    values = address.values
    values.join(', ') unless values.reject(&:empty?).empty?
  end
end


