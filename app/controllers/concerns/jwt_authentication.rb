module JwtAuthentication
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
    ERROR_CLASSES = [
      JWT::DecodeError,
      JWT::ExpiredSignature
    ].freeze

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    rescue *ERROR_CLASSES => exception
      handle_exception exception
    end
  end


  def self.handle_exception(exception)
    case exception
    when JWT::DecodeError
      { error: { token: 'Invalid Token' }, status: :bad_request }
    when JWT::ExpiredSignature
      { error: { token: 'Token has Expired' }, status: :unauthorized }
    end
  end
end