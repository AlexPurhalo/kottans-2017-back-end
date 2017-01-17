Sequel.migration do
  up do
    create_table :votes do
      primary_key :id
      Boolean :like, null: false
      foreign_key :user_id, :users
      foreign_key :post_id, :posts
    end
  end

  down do
    drop_table :votes
  end
end