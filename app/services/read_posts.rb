class ReadPostsService
  def initialize(params)
    @category_name = params[:category]
    @category = Category.where(name: category_name).first
    @posts = nil
    @page, @size = params[:page], params[:size]
  end

  attr_reader :category_name, :category, :page, :size, :size, :page, :last_num, :init_num, :limit_num
  attr_accessor :posts

  def show_posts
    has_category? ? posts_with_category : all_posts
    with_pagination? && paginate
    @posts
  end

  private
  def has_category?; category_name.nil? ? false : true; end
  def posts_with_category; sort_by_category && sort_by_commit_date && @posts; end
  def sort_by_category; @posts = category.posts; end
  def sort_by_commit_date; @posts = @posts.sort_by {|obj| obj.created_at }.reverse; end
  def all_posts; (@posts = Post.all) && sort_by_commit_date && @posts; end

  def with_pagination?; !page.nil? && !size.nil? ? true : false; end

  def find_last_num; @posts.count-1; end
  def find_init_num; size.to_i * page.to_i - size.to_i; end
  def find_limit_num; size.to_i * page.to_i - 1; end

  def pag_last_item; [last_num, limit_num].min; end

  def paginate
    @last_num, @init_num, @limit_num = find_last_num, find_init_num, find_limit_num

    i, new_items_arr = init_num, Array.new
    while i <= pag_last_item
      new_items_arr.push(@posts[i])
      i += 1
    end

    @posts = new_items_arr
  end
end