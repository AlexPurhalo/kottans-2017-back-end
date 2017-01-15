class User < Sequel::Model
  def validate
    super
    errors.add(:username, 'Username cannot be empty') if !username || username.empty?
    errors.add(:username, 'This username is already taken') if username && new? && User[username: username]

    errors.add(:bcrypted_password, 'Password can not be empty') if !bcrypted_password || bcrypted_password.empty?
  end

  def before_create
    self.access_token ||= SecureRandom.hex
    super
  end
end