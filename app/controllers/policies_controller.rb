# frozen_string_literal: true

require 'net/http'

class PoliciesController < ApplicationController
  def index
    uri = URI("http://policy-service:3001/v1/policies")
    response = Net::HTTP.get_response(uri.host, uri.path, uri.port)
    @policies = JSON.parse(response.body, symbolize_names: true)
  end
end
