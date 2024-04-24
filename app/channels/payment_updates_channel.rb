class PaymentUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "PaymentUpdatesChannel"
    stream_for "PaymentUpdatesChannel"
  end

  def receive
    ActionCable.server.broadcast 'PaymentUpdatesChannel', "Hello from the Rails app."
  end
end 
