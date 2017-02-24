class AddVotingAnswer
  def initialize(params, headers)
    @post, @variant, @user = Post[params[:post_id]], Variant[params[:variant_id]], User[headers['X-User-Id']]
    @answer = nil
  end

  def process; create_answer && add_answer_to_user && add_answer_to_post && add_answer_to_variant; end
  def show; @post.voting_answers; end

  private
  def create_answer; @answer = VotingAnswer.create(post_id: @post.id, variant_id: @variant.id, user_id: @user.id); end
  def add_answer_to_user; @user.add_voting_answer(@answer); end
  def add_answer_to_post; @post.add_voting_answer(@answer); end
  def add_answer_to_variant; @variant.add_voting_answer(@answer); end
end