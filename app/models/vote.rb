class Vote < Sequel::Model
  many_to_one :user
  many_to_one :post
end