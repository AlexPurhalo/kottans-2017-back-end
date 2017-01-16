class Category < Sequel::Model
  many_to_many :posts, left_key: :category_id, right_key: :post_id, join_table: :posts_categories
end