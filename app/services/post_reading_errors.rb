class PostsReadingErrorsService
  def initialize(params)
    (@errors = Array.new) && (@category_name = params[:category]) && (@category = nil)
  end

  attr_accessor :errors, :category
  attr_reader :category_name

  def category_exist?; find_category && (category.nil? ? false : true); end

  def find_category; @category = Category.where(name: category_name).first; end

  def validation_errors
    errors.push('Category with this name does not exist') if category_name && !category_exist?
    errors
  end
end