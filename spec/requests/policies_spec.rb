# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Policies', type: :request do
  describe '#index' do
    it 'success' do
      policies_controller = PoliciesController.new
      policies = [{ id: 1, insuredAt: '2021-01-01', insuredUntil: '2022-01-01', insured: { name: 'John Doe', cpf: '123456789' }, vehicle: { plate: 'ABC123', brand: 'Toyota', model: 'Camry', year: 2020 } }]
      allow(policies_controller).to receive(:retrieve_policies).and_return(policies)

      policies_controller.index

      expect(policies_controller.instance_variable_get(:@policies)).to eq(policies)
    end

    it 'fails' do
      policies_controller = PoliciesController.new
      allow(policies_controller).to receive(:send_request).and_raise(Errno::ECONNREFUSED)

      expect { policies_controller.send(:retrieve_policies) }.to raise_error(Errno::ECONNREFUSED)
    end
  end
end
