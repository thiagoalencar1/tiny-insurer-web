# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def index
    client = Graphlient::Client.new('http://policy-api:3003/graphql', http_options: { read_timeout: 20, write_timeout: 30 })

    query = QueryHelper::Client.parse <<-'GRAPHQL'
      query {
        policies {
          id
          insuredAt
          insuredUntil
          insured {
            name
            cpf
          }
          vehicle {
            plate
            brand
            model
            year
          }
        }
      }
    GRAPHQL

    response = client.query(query)
    @policies = response.data.policies
  end
end
