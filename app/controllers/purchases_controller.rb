class PurchasesController < ApplicationController
  def new
  end

  def create
    stripe_service = PurchasesService.new(params)
    result = stripe_service.charge
    status = result.has_key?(:error) && :unprocessable_entity || :ok
    render json: result, status: status
  end

end
