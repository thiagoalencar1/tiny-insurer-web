require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Creates user' do
    it 'successfuly' do
      expect { create(:user) }.to change { User.count }.by(1)
    end

    it 'and its unique' do
      create(:user)
      should validate_uniqueness_of(:email).case_insensitive
    end
  end
end
