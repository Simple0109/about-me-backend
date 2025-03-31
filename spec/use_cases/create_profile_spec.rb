require 'rails_helper'

RSpec.describe CreateProfile do
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      name: 'Test User',
      bio: 'Test bio',
      avatar_url: 'http://example.com/avatar.jpg',
      location: 'Tokyo',
      website: 'http://example.com'
    }
  end

  describe '#execute' do
    context 'with valid params' do
      it 'creates a profile' do
        result = described_class.new(user, valid_params).execute

        expect(result[:success]).to be true
        expect(result[:profile]).to be_persisted
        expect(user.profile).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { valid_params.merge(name: '') }

      it 'returns errors' do
        result = described_class.new(user, invalid_params).execute

        expect(result[:success]).to be false
        expect(result[:errors]).to include("Name can't be blank")
      end
    end
  end
end
