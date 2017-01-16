Sequel.migration do
  up do
    create_table :posts do
      primary_key :id
      String :title, null: false
      String :description, null: false
      foreign_key :user_id
      Time :created_at
    end
  end

  down do
    drop_table :posts
  end
end