# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def index
    sleep(1)
    return nil if retrieve_policies.nil?
    @policies = retrieve_policies.reverse
  end

  def new
  end

  def create
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

    @payment_id = session.id
    @payment_url = session.url

    send_request(create_policy_mutation)

    redirect_to policies_path
  end

  def show
    redirect_to policies_path
  end

  private

  def retrieve_policies
    response = send_request(get_policies_query)
    parse_response(response)
  end

  def create_policy_mutation
    {
      "query": "mutation createPolicyMutation (
            $insuredAt: String!
            $insuredUntil: String!
            $insuredName: String!
            $insuredCpf: String!
            $vehiclePlate: String!
            $vehicleBrand: String!
            $vehicleModel: String!
            $vehicleYear: Int!
            $status: String!
            $paymentId: String!
            $paymentLink: String!
      )
      {
        createPolicy (
          input: {
            policy:{
              insuredAt: $insuredAt
              insuredUntil: $insuredUntil
              status: $status
              paymentId: $paymentId
              paymentLink: $paymentLink
              insured: {
                name: $insuredName,
                cpf: $insuredCpf
              }
              vehicle: {
                plate: $vehiclePlate
                brand: $vehicleBrand
                model: $vehicleModel
                year: $vehicleYear
              }
            }
          }
        ) { success }
      }",
      "variables": {
        "insuredAt": params[:insured_at],
        "insuredUntil": params[:insured_until],
        "status": "pending",
        "insuredName": params[:insured_name],
        "insuredCpf": params[:insured_cpf],
        "vehiclePlate": params[:vehicle_plate],
        "vehicleBrand": params[:vehicle_brand],
        "vehicleModel": params[:vehicle_model],
        "vehicleYear": params[:vehicle_year].to_i,
        "paymentId": @payment_id,
        "paymentLink": @payment_url
      }
    }
  end

  def send_request(query)
    uri = URI('http://tiny-insurer-graphql:3003/graphql')
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{token}"
      request['Content-Type'] = 'application/json'
      request.body = query.to_json
      http.request(request)
    end
  end

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true)[:data][:policies]
  end

  def get_policies_query
    {
      query: 'query { policies {
        id status insuredAt insuredUntil paymentId paymentLink
        insured { name cpf }
        vehicle { plate brand model year }
        }
      }'
    }
  end

  def token
    data = { email: current_user.email, provider: current_user.provider }
    JWT.encode(data, 'secret', 'HS256')
  end
end
