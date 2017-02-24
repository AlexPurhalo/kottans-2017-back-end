class CreateComment
  def initialize(params, headers)
    @user, @post = User[headers['X-User-Id']], Post[params[:post_id]]
    @body = params[:body]
  end

  attr_reader :user, :post, :body, :comment

  def show_comments; process && post.comments; end

  private
  def process; create_comment && add_to_user && add_to_post; end
  def create_comment; @comment = Comment.create(body: body, user_id: @user.id); end
  def add_to_user; user.add_comment(comment); end
  def add_to_post; post.add_comment(comment); end
end