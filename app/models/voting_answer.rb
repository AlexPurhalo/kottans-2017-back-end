class VotingAnswer < Sequel::Model
  many_to_one :user
  many_to_one :variant
  many_to_one :post
end