Sequel.migration do
  up do
    create_table :voting_answers do
      primary_key :id
      foreign_key :variant_id, :variants, null: false
      foreign_key :user_id, :users, null: false
      foreign_key :post_id, :posts, null: false
    end
  end

  down do
    drop_table :voting_answers
  end
end