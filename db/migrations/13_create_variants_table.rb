Sequel.migration do
  up do
    create_table :variants do
      primary_key :id
      String :body, null: false
      foreign_key :post_id, :posts
    end
  end

  down do
    drop_table :variants
  end
end