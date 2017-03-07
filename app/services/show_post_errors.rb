class ShowPostErrors
  def initialize(params)
    @errors = Array.new

    @post = Post[params[:post_id]]
  end

  attr_reader :post
  attr_accessor :errors

  def post_exist?; post.nil? ? false : true; end


  def validation_errors
    errors.push('provided "post_id" does not matches with any post in DB') unless post_exist?
    errors
  end
end