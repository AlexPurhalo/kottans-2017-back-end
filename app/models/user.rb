class User < Sequel::Model
  def validate
    super
    errors.add(:username, 'Username cannot be empty') if !username || username.empty?
    errors.add(:username, 'This username is already taken') if username && new? && User[username: username]
  end

  def before_create
    self.access_token ||= SecureRandom.hex
    super
  end

  one_to_many :posts
  one_to_many :votes
  one_to_many :comments
  many_to_many :parties, left_key: :user_id, right_key: :party_id, joint_table: :parties_users
  one_to_many :answers
  many_to_many :voting_answers, left_key: :user_id, right_key: :voting_answer_id, join_table: :voting_answers_users
end