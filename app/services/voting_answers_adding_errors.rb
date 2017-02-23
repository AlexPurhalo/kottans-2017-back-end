class AddVotingAnswersErrorsService
  def initialize(params)
    @errors = Array.new
    @post, @variant = Post[params[:post_id]], Variant[params[:variant_id]]
  end

  attr_accessor :errors

  def validation_errors
    errors.push('Post with this "post_id" does not exist') unless has_post?
    errors.push('Variant with this "variant_id" does not exist') unless has_variant?
    errors.push('Provided variant not belongs to provided post') if has_post_and_variant? && !variant_belongs_to_post?
    errors
  end

  private
  def has_post?; @post.nil? ? false : true; end
  def has_variant?; @variant.nil? ? false : true; end
  def has_post_and_variant?; has_post? && has_variant? ? true : false; end
  def variant_belongs_to_post?; @variant.post.id == @post.id ? true : false; end
end