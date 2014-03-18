describe 'stripeTest.Payment', ->
  $.fx.off = true
  $form = null
  payment = null

  beforeEach ->
    fixture.load 'payment'
    $form = $('#test-form')
    payment = new stripeTest.Payment stripeKey: '123', form: $form

  describe '#retrieveStripeToken', ->
    it 'disables the form submit button', ->
      spyOn(payment, 'disableSubmit')
      payment.retrieveStripeToken()
      expect(payment.disableSubmit).toHaveBeenCalledWith true

  describe '#responseHandler', ->
    describe 'on success', ->
      it 'submits form', ->
        spyOn(payment, 'submitForm')
        payment.responseHandler 200, { id: 123 }
        expect(payment.submitForm).toHaveBeenCalledWith(123)

    describe 'on error', ->
      it 'renders error', ->
        spyOn(payment, 'renderError')
        payment.responseHandler 422, { error: { message: 'Error' } }
        expect(payment.renderError).toHaveBeenCalledWith { message: 'Error' }

  describe '#fadeRemoveError', ->
    it 'removes the payment error', ->
      $error = $('<div />', class: 'payment-errors').html('Error')
      $form.prepend $error
      payment.fadeRemoveError $error
      expect($form.find('.payment-errors').length).toBeFalsy()

  describe '#renderError', ->
    it 'prepends the error', ->
      spyOn($.fn, 'prepend')
      payment.renderError { message: 'This is an error' }
      expect($form.prepend).toHaveBeenCalled()

    it 'fade and removes the error', ->
      spyOn(payment, 'fadeRemoveError')
      payment.renderError { message: 'This is an error' }
      expect(payment.fadeRemoveError).toHaveBeenCalled()

    it 'reenable form submit', ->
      spyOn(payment, 'disableSubmit')
      payment.renderError { message: 'This is an error' }
      expect(payment.disableSubmit).toHaveBeenCalledWith false

  describe '#submitForm', ->
    it 'appends a hidden token input', ->
      spyOn(HTMLFormElement.prototype, 'submit')
      payment.submitForm('123')
      expect($form.find('input[name="stripeToken"]').val()).toEqual '123'

  describe '#disableSubmit', ->
    it 'disables the submit button', ->
      payment.disableSubmit true
      expect($form.find('input[type="submit"]').is(':disabled')).toBeTruthy()

    it 'enables the submit button', ->
      payment.disableSubmit false
      expect($form.find('input[type="submit"]').is(':disabled')).toBeFalsy()



