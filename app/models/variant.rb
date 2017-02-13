class Variant < Sequel::Model
  many_to_one :post
  many_to_many :users
  many_to_many :voting_answers, left_key: :variant_id, righ_key: :voting_answer_id, join_table: :voting_answers_variants
end