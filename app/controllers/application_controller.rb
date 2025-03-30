class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  protected

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      decoded = Auth.decode(token)
      if decoded.is_a?(Hash) && decoded[:error]
        false
      else
        @current_user = User.find_by(id: decoded[:user_id])
      end
    end
  end

  def render_unauthorized
    render json: { error: I18n.t('auth.errors.authentication_failed') }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  protected

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      decoded = Auth.decode(token)
      if decoded.is_a?(Hash) && decoded[:error]
        false
      else
        @current_user = User.find_by(id: decoded[:user_id])
    end
  end

  def render_unauthorized
    render json: { error: I18n.t('auth.error.authentication_failed' )}, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
