class CreatePostService
  def initialize(params, user_id)
    @post = nil
    @user_id = user_id

    @title = params[:title]
    @description = params[:description]
    @with_party = params[:with_party]
    @with_voting = params[:with_voting]
    @variants = params[:variants]
    @categories = params[:categories]
  end

  attr_reader :title, :description, :categories, :with_party, :with_voting, :variants, :user_id


  def show_post;
    create_post && add_to_user && add_categories_relationship
    with_voting == true && add_voting
    @post
  end

  private
  def create_post
    @post = Post.create(
        title: title, description: description, with_party: with_party, with_voting: with_voting
    )
  end

  def add_to_user; User[user_id].add_post(@post); end

  def add_categories_relationship
    categories.each do |category_name|
      category = Category.where(name: category_name).first
      category.nil? && (category = Category.create(name: category_name))
      category.add_post(@post)
    end
  end

  def add_voting; variants.each { |variant| Variant.create(body: variant, post_id: @post.id)}; end
end