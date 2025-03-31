require 'rails_helper'

RSpec.describe 'Api::V1::Profiles', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_token}" } }
  let(:valid_attributes) do
    {
      name: 'Test User',
      bio: 'Test bio',
      avatar_url: 'http://example.com/avatar.jpg'
    }
  end

  describe 'POST /api/v1/profile' do
    context 'with valid parameters' do
      it 'creates a new profile' do
        expect {
          post '/api/v1/profile', params: { profile: valid_attributes }, headers: headers
        }.to change(Profile, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response['name']).to eq('Test User')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        post '/api/v1/profile', params: { profile: { name: '' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'PATCH /api/v1/profile' do
    let!(:profile) { create(:profile, user: user) }

    context 'with valid parameters' do
      it 'updates the profile' do
        patch '/api/v1/profile', params: { profile: { name: 'Updated Name' } }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json_response['name']).to eq('Updated Name')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        patch '/api/v1/profile', params: { profile: { name: '' } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
