  class PostCreatingErrorsService
  def initialize(params)
    @errors = Array.new

    @title = params[:title]
    @description = params[:description]
    @with_party = params[:with_party]
    @with_voting = params[:with_voting]
    @variants = params[:variants]
    @categories = params[:categories]
  end

  attr_accessor :errors

  attr_reader :title, :description, :categories, :with_party, :with_voting, :variants

  def validation_errors
    errors.push('Provide "description" param') unless title && description
    errors.push('Provide "title" param') if title && title.length < 1
    errors.push('"description" param can not be empty') if description && description.length < 1
    errors.push('Provide "categories" param') unless categories
    errors.push('Provide items for "categories" array param') if categories && categories.length < 1
    errors.push('Provide "with_party" boolean param') if with_party === nil
    errors.push('Provide "with_voting" boolean param') if with_voting === nil
    errors.push('To create voting, provide "variants" array param') if with_voting == true && !variants
    errors.push('Provide items for "variants" param') if with_voting == true && variants && variants.empty?
    errors
  end
end