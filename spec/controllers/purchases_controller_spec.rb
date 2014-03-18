require 'spec_helper'

describe PurchasesController do
  let(:purchase_params) do
    {
      stripeToken: '123',
      billing_address: {
        address_line1: 'Dummy Street'
      },
      shipping_address: {
        address_line1: ''
      }
    }
  end

  describe 'on successfully charge' do
    before do
      PurchasesService.any_instance.
        should_receive(:charge).
        and_return({})
      post :create, purchase_params
    end

    it 'responds with the charge' do
      expect(JSON.parse(response.body)).to eql({})
    end

  end

  describe 'on failed charge' do
    let(:error) do
      { "error" => 'Something went wrong' }
    end

    before do
      PurchasesService.any_instance.
        should_receive(:charge).
        and_return error
      post :create, purchase_params
    end

    it 'sets error message' do
      expect(JSON.parse(response.body)).to eql(error)
    end

  end

end

