class Post < Sequel::Model
  many_to_one :user
  many_to_many :categories, left_key: :post_id, right_key: :category_id, join_table: :posts_categories
  one_to_many :votes
  one_to_many :comments
  one_to_one :party
  one_to_many :variants

  def before_create
    self.created_at = Time.now
    super
  end
end