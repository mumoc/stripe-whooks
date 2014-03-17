window.stripeTest ||= {}

stripeTest.Payment = (->
  Payment = (options) ->
    Stripe.setPublishableKey options.stripeKey
    @$form = options.form
    @$container = @$form.parents('section')
    @$form.submit => @retrieveStripeToken()
    @

  Payment::retrieveStripeToken = ->
    @disableSubmit true
    Stripe.card.createToken @$form, $.proxy(@responseHandler, @)
    false

  Payment::responseHandler = (status, response) ->
    if response.error then @renderError(response.error) else @submitForm(response.id)

  Payment::renderError = (error) ->
    $paymentError = $('<div />', class: 'payment-errors' ).html error.message
    @$form.prepend $paymentError
    @fadeRemoveError $paymentError
    @disableSubmit false

  Payment::fadeRemoveError = ($error) ->
    $error.fadeOut 5000, -> @.remove()

  Payment::renderSuccess = (charge) ->
    charge.amount = (charge.amount/100).toFixed(2)
    @$container.html HandlebarsTemplates['purchases/success'](charge)

  Payment::submitForm = (tokenId) ->
    input = $('<input />', { value: tokenId, name: 'stripeToken', type: 'hidden' })
    @$form.append input
    @sendPayment @$form.attr('action'), @$form.serialize()

  Payment::sendPayment = (url, data) ->
    call = $.post url, data
    call.success (response) =>
      @renderSuccess response.charge
    call.error (response) =>
      errorMessage = { message: $.parseJSON(response.responseText).error }
      @renderError errorMessage

  Payment::disableSubmit = (disabled) ->
    @$form.find('input[type="submit"]')
      .prop('disabled', disabled)

  Payment
)()


