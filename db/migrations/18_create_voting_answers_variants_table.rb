Sequel.migration do
  up do
    create_table :voting_answers_variants do
      primary_key :id
      foreign_key :variant_id, :variants
      foreign_key :voting_answer_id, :voting_answers
    end
  end

  down do
    drop_table :voting_answers_variants
  end
end