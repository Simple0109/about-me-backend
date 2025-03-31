require 'rails_helper'

RSpec.describe UpdateProfile do
  let(:user) { create(:user, :with_profile) }

  let(:valid_params) do
    {
      name: 'Updated Name',
      bio: 'Updated bio',
      avatar_url: 'http://example.com/new_avatar.jpg'
    }
  end

  describe '#execute' do
    context 'with valid params' do
      it 'updates the profile' do
        result = described_class.new(user, valid_params).execute

        expect(result[:success]).to be true
        expect(result[:profile].name).to eq('Updated Name')
        expect(result[:profile].bio).to eq('Updated bio')
        expect(result[:profile].avatar_url).to eq('http://example.com/new_avatar.jpg')
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

    context 'when profile does not exist' do
      let(:user_without_profile) { create(:user) }

      it 'returns error' do
        result = described_class.new(user_without_profile, valid_params).execute

        expect(result[:success]).to be false
        expect(result[:errors]).to include('Profile not found')
      end
    end
  end
end
