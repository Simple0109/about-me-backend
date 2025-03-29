require 'jwt'

module Auth
  SECRET_KEY = Rails.application.credentials.secret_key_base
  ALGORITHM = 'HS256'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    { error: I18n.t('auth.errors.expired_token') }
  rescue JWT::VerificationError
    { error: I18n.t('auth.errors.invalid_signature') }
  rescue JWT::DecodeError
    { error: I18n.t('auth.errors.invalid_token') }
  end

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user&.authenticate(password) ? user : { error: I18n.t('auth.errors.invalid_credentials') }
  end
end
