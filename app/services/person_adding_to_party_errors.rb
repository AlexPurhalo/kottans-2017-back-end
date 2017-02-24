class PersonAddingToPartyErrors
  def initialize(params)
    @post = Post[params[:post_id]]
    @errors = Array.new
  end

  attr_accessor :errors

  def validation_errors
    errors.push('Post with this ":post_id" does not exist') unless @post
    errors
  end
end