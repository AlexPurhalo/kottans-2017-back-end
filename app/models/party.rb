class Party < Sequel::Model
  many_to_many :users, left_key: :party_id, right_key: :user_id, joint_table: :parties_users
  many_to_one :post
end