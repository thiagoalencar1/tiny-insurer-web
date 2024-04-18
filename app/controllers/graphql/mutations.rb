# frozen_string_literal: true

module Graphql::Mutations
  def self.create_policy(params, payment_id, payment_url)
    {
      query: "mutation createPolicy(
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
      variables: {
        insuredAt: params[:insured_at],
        insuredUntil: params[:insured_until],
        status: "pending",
        insuredName: params[:insured_name],
        insuredCpf: params[:insured_cpf],
        vehiclePlate: params[:vehicle_plate],
        vehicleBrand: params[:vehicle_brand],
        vehicleModel: params[:vehicle_model],
        vehicleYear: params[:vehicle_year].to_i,
        paymentId: payment_id,
        paymentLink: payment_url
      }
    }
  end
end
