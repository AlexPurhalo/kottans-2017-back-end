class CreateCommentErrors
  def initialize(params)
    @errors = Array.new
    @body = params[:body]
    @post = Post[params[:post_id]]
  end

  attr_accessor :errors
  attr_reader :body

  def validation_errors
    errors.push('Post with this "post_id" does not exist') if @post.nil?
    errors.push('Provide "body" param') if body.nil?
    errors.push('"body" param can not be empty') if !body.nil? && body.length < 1
    errors
  end
end