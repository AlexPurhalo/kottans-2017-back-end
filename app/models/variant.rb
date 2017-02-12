class Variant < Sequel::Model
  many_to_one :post
  many_to_many :users
end