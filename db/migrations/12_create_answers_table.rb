Sequel.migration do
  up do
    create_table :answers do
      primary_key :id
      String :body
      foreign_key :user_id, :users
      foreign_key :question_id, :questions
    end
  end

  down do
    drop_table :answers
  end
end