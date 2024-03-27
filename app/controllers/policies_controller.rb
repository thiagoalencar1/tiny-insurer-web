# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def index
    @policies = retrieve_policies
  end

  def new
  end

  private

  def retrieve_policies
    response = send_request(get_policies_query)
    parse_response(response)
  end

  def create_policy_mutation(insured_at, insured_until, insured_name, insured_cpf, vehicle_plate, vehicle_brand, vehicle_model, vehicle_year)
    {
      query: 'mutation createPolicyMutation(
        $insuredAt: String!
        $insuredUntil: String!
        $insuredName: String!
        $insuredCpf: String!
        $vehiclePlate: String!
        $vehicleBrand: String!
        $vehicleModel: String!
        $vehicleYear: Int!
      ) {
        createPolicy(
          input: {
            policy: {
              insuredAt: $insuredAt
              insuredUntil: $insuredUntil
              insured: { name: $insuredName, cpf: $insuredCpf }
              vehicle: {
                plate: $vehiclePlate
                brand: $vehicleBrand
                model: $vehicleModel
                year: $vehicleYear
              }
            }
          }
        ){ success }
      }'
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
        id insuredAt insuredUntil
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
