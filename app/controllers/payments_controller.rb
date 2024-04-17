class PaymentsController < ApplicationController
  def new
    render 'payments/new'
  end
  
  def success
    #handle successful payments
    render 'payments/success', notice: "Purchase Successful"
  end
  
  def cancel
    #handle if the payment is cancelled
    render 'payments/cancel', notice: "Purchase Unsuccessful"
  end
end
