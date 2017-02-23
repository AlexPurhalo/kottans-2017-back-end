class PostPreferencesErrorsService
  def initialize(params)
    @errors = Array.new
    @post = Post[params[:post_id]]
    @like = params[:like]
  end

  attr_reader :post
  attr_accessor :errors

  def validation_errors
    errors.push('Post with this "post_id" is not exist') unless @post
    errors.push('Provide "like" boolean') if @like.nil?
    errors
  end
end