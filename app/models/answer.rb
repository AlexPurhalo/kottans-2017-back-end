class Answer < Sequel::Model
  many_to_one :user
  many_to_one :question
end