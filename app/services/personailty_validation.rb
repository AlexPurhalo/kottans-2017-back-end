class AuthErrorsService
  def initialize(headers)
    @access_token, @user_id, @errors = headers['X-Access-Token'], headers['X-User-Id'], Array.new
  end

  attr_reader :access_token, :user_id
  attr_accessor :errors

  def validation_errors
    errors.push('Provide "X-User-Id" to headers') unless user_id
    errors.push('Provide "X-Access-Token" to headers') unless access_token
    errors.push('Personality confirmation is failed') if user_id && access_token != User[user_id].access_token
    errors
  end
end