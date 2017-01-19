class Comment < Sequel::Model
  many_to_one :user
  many_to_one :post

  def before_create
    self.created_at = Time.now
    super
  end
end