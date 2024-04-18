# frozen_string_literal: true

module Graphql::Queries
  def self.get_policies
    {
      query: 'query { policies {
        id status insuredAt insuredUntil paymentId paymentLink
        insured { name cpf }
        vehicle { plate brand model year }
        }
      }'
    }
  end
end
