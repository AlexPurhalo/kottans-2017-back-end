Sequel.migration do
  up do
    create_table :posts_categories do
      primary_key :id
      foreign_key :category_id, :categories
      foreign_key :post_id, :posts
    end
  end

  down do
    drop_table :posts_categories
  end
end