# frozen_string_literal: true

require 'graphql/client/http'

module QueryHelper
  HTTP = GraphQL::Client::HTTP.new('http://policy-graphql:3003/graphql') do
    def headers(*)
      { "Content-Type": "application/json" }
    end
  end

  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
