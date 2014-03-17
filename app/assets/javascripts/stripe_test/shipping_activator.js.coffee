window.stripeTest ||= {}

stripeTest.ShippingActivator = (->
  ShippingActivator = (@shippingFieldset, @shippingCheck) ->
    @toggleBillingClass()
    @shippingCheck.on 'change', =>
      @cleanForm()
      @toggleBillingClass()
    @

  ShippingActivator::cleanForm = ->
    @shippingFieldset.find('input[type="text"]')
      .val ''

  ShippingActivator::toggleBillingClass = ->
    @shippingFieldset.toggleClass 'same-as-billing', !@shippingCheck.is(':checked')

  ShippingActivator
)()

