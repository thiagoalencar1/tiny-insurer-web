module Graphql::Sender
  GRAPHQL_URL = URI('http://tiny-insurer-graphql:3003/graphql')

  def send_to_graphql(query_or_mutation)
    body = query_or_mutation.to_json
    header = {'Content-Type': 'application/json', 'Authorization': "Bearer #{token}"}
    Net::HTTP.post(GRAPHQL_URL, body, header)
  end

  private

  def token
    data = { email: current_user.email, provider: current_user.provider }
    JWT.encode(data, 'secret', 'HS256')
  end
end