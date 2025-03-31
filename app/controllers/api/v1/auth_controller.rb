class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate, only: [:login, :signup]

  def login
    user = Auth.authenticate(params[:email], params[:password])
    if user
      token = Auth.encode(user_id: user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          github_username: user.github_username,
          qiita_username: user.qiita_username
        }
      }, status: :ok
    else
      render json: { error: I18n.t('auth.errors.invalid_credentials') }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params)
    if user.save
      token = Auth.encode(user_id: user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          github_username: user.github_username,
          qiita_username: user.qiita_username
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :github_username, :qiita_username)
  end

  # 開発環境用テストアクション
  def test_token
    test_user = User.first || User.create(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    token = Auth.encode(user_id: test_user.id)
    render json: {
      token: token,
      user: {
        id: test_user.id,
        email: test_user.email
      }
    }, status: :ok
  end
end
