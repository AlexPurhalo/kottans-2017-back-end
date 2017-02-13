Sequel.migration do
  up do
    create_table :voting_answers_users do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :voting_answer_id, :voting_answers
    end
  end

  down do
    drop_table :voting_answers_users
  end
end