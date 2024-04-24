# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :authenticate_user!

  include Graphql::Sender

  def index
    sleep(1)
    return nil if policies_list.nil?
    @policies = policies_list.reverse
  end

  def new
  end

  def create
    # Utilizei aqui o Checkout::Session para criar um link de pagamento.
    # Poderia ser utilizado o PaymentIntent ou o PaymentLink.
    # Preferi o Checkout::Session pois, na experiência que tive,
    # foi o único que expirou o link após a efetivação do pagamento.
    # Também é válido deixar registrado que, no cenário de ser uma sessão criada
    # dentro de uma sessão de usuário, pode-se criar um customer e associar
    # o pagamento a ele, tornando o processo mais fácil.
    session = Stripe::Checkout::Session.create( 
      payment_method_types: ['card'],
      line_items: [{
        price: 'price_1Oz13BAHgxUyd1DWBsgPqlxJ',
        quantity: 1,
      }],
      mode: 'payment',
      success_url:  payments_success_url,
      cancel_url: payments_cancel_url
     )

    payment_id = session.id
    payment_url = session.url

    send_to_graphql(Graphql::Mutations.create_policy(params, payment_id, payment_url))

    redirect_to policies_path
  end

  def show
    redirect_to policies_path
  end

  private

  def policies_list
    response = send_to_graphql(Graphql::Queries.get_policies)
    JSON.parse(response.body, symbolize_names: true)[:data][:policies]
  end
end
