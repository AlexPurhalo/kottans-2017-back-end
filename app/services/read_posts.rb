class ReadPostsService
  def initialize(params)
    @category_name = params[:category]
    @category = Category.where(name: category_name).first
    @posts = nil
  end

  attr_reader :category_name, :category

  def show_posts; category_name ? posts_with_category : all_posts; end

  private
  def posts_with_category; sort_by_category && sort_by_commit_date && @posts; end
  def sort_by_category; @posts = category.posts; end
  def sort_by_commit_date; @posts = @posts.sort_by {|obj| obj.created_at }.reverse; end
  def all_posts; (@posts = Post.all) && sort_by_commit_date && @posts; end
end