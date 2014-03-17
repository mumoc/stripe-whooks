class ReceiptMailer < ActionMailer::Base
  default from: 'mumo.crls@gmail.com'

  def send_receipt charge
    @charge = charge
    @amount = charge.amount.to_i/100
    mail(
      to: charge.metadata.email,
      subject: "Stripe Receipt Number: #{charge.id}"
    )
  end
end
