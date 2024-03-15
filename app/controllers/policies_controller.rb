# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def index # rubocop:disable Metrics/MethodLength
    data = { email: current_user.email, provider: current_user.provider }
    token = JWT.encode(data, 'secret', 'HS256')

    uri = URI('http://tiny-insurer-graphql:3003/graphql')
    query = { 'query': 'query { policies { id insuredAt insuredUntil insured { name cpf } vehicle { plate brand model year }}}' }
    headers = {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
    conn = Net::HTTP.new(uri.host, uri.port)
    response = conn.post(uri.path, query.to_json, headers)
    @policies = JSON.parse(response.body, symbolize_names: true)[:data][:policies]
  end
end

  #   client = Graphlient::Client.new(
  #     'http://policy-graphql:3003/graphql',
  #     headers: { 'Authorization' => "Bearer secret" },
  #     http_options: { read_timeout: 20, write_timeout: 30 }
  #   )

  #   response = client.query(query)
  #   @policies = response.data.policies
