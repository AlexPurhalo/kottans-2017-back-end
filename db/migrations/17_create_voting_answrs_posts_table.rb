Sequel.migration do
  up do
    create_table :voting_answers_posts do
      primary_key :id
      foreign_key :post_id, :posts
      foreign_key :voting_answer_id, :voting_answers
    end
  end

  down do
    create_table :voting_answers_posts
  end
end