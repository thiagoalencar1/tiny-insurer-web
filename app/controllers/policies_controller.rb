# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def index
    @policies = retrieve_policies
  end

  private

  def retrieve_policies
    response = send_request(query)
    parse_response(response)
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

  def query
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
