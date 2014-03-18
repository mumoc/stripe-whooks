require 'spec_helper'
require 'stripe_mock'

describe PurchasesService do
  before { StripeMock.start }
  after { StripeMock.stop }

  let(:stripe_token) do
    StripeMock.generate_card_token({
      last4: '1123',
      exp_month: 11,
      exp_year: 2099
    })
  end

  let(:purchase_params) do
    {
      stripeToken: stripe_token,
      billing_address: {
        address_line1: 'Dummy Test'
      },
      shipping_address: {
        address_line1: ''
      }
    }
  end

  subject { PurchasesService.new purchase_params }

  describe '#charge' do
    describe 'on successfull charge' do
      it 'success' do
        expect(subject.charge[:charge]).to be_kind_of(Stripe::Charge)
      end
    end

    describe 'on failed charge' do
      before do
        StripeMock.prepare_card_error(:card_declined)
      end

      it 'returns an error hash' do
        expect(subject.charge).to eql({ error: 'The card was declined' })
      end
    end
  end
end
