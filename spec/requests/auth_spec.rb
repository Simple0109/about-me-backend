require 'rails_helper'
require 'factory_bot'

RSpec.describe 'Auth API', type: :request do
  include FactoryBot::Syntax::Methods

  let(:valid_attributes) {
    {
      email: Faker::Internet.unique.email,
      password: 'password123',
      password_confirmation: 'password123',
      github_username: Faker::Internet.unique.username,
      qiita_username: Faker::Internet.unique.username
    }
  }

  let(:invalid_attributes) {
    {
      email: 'invalid_email',
      password: 'short',
      password_confirmation: 'mismatch'
    }
  }

  describe 'POST /api/v1/login' do
    let!(:user) { create(:user, password: 'password123') }

    context 'with valid credentials' do
      before { post '/api/v1/login', params: { email: user.email, password: 'password123' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a valid JWT token' do
        expect(json['token']).not_to be_nil
      end

      it 'returns user details' do
        expect(json['user']['id']).to eq(user.id)
        expect(json['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      before { post '/api/v1/login', params: { email: user.email, password: 'wrong_password' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(json['error']).to eq(I18n.t('auth.errors.invalid_credentials'))
      end
    end
  end

  describe 'POST /api/v1/signup' do
    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post '/api/v1/signup', params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'returns status code 201' do
        post '/api/v1/signup', params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it 'returns user details with token' do
        post '/api/v1/signup', params: valid_attributes
        expect(json['token']).not_to be_nil
        expect(json['user']['email']).to eq(valid_attributes[:email])
      end
    end

    context 'with invalid params' do
      before { post '/api/v1/signup', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        expect(json['errors']).to include("Password is too short (minimum is 6 characters)")
        expect(json['errors']).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe 'Auth module' do
    let!(:user) { create(:user) }

    describe '.encode' do
      it 'generates a valid JWT token' do
        token = Auth.encode(user_id: user.id)
        expect(token).not_to be_nil
      end
    end

    describe '.decode' do
      let(:valid_token) { Auth.encode(user_id: user.id) }

      it 'decodes a valid token' do
        decoded = Auth.decode(valid_token)
        expect(decoded[:user_id]).to eq(user.id)
      end

      it 'handles invalid token' do
        decoded = Auth.decode('invalid.token.here')
        expect(decoded[:error]).to eq(I18n.t('auth.errors.invalid_token'))
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
