class PaymentsController < ApplicationController
  def new
    render 'payments/new'
  end
  
  def success
    #handle successful payments
    render 'payments/success', notice: "Compra bem sucedida!"
  end
  
  def cancel
    #handle if the payment is cancelled
    render 'payments/cancel', notice: "Falha no processo de compra."
  end

  def live_confirm
    # PaymentUpdatesChannel.broadcast_to("PaymentUpdatesChannel", "Hello from the controller.")
    ActionCable.server.broadcast("PaymentUpdatesChannel", params.to_json)
  end
end
