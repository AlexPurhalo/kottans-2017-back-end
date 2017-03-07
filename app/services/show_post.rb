class ShowPost
  def initialize(params); @post = Post[params[:post_id]]; end

  attr_reader :post

  def show_post; post; end
end