class AddPreferenceService
  def initialize(params, headers)
    @post = Post[params[:post_id]]
    @user = User[headers['X-User-Id']]
    @vote = Vote.where(user_id: @user.id, post_id: @post.id).first
    @like = params[:like]
  end

  def process_vote
    if vote_exist?
      has_same_like_val? ? destroy_vote : change_vote
    else
      create_vote_with_relationships
    end
  end

  def show_votes; @post.votes; end
  private
  def has_same_like_val?; @vote.like === @like ? true : false; end
  def vote_exist?; @vote.nil? ? false : true; end
  def create_vote_with_relationships; create_vote && add_post_to_vote && add_user_to_vote && @vote.save; end
  def create_vote; @vote = Vote.create(like: @like); end
  def add_post_to_vote; @vote.post = @post; end
  def add_user_to_vote; @vote.user = @user; end
  def save_vote; @vote.save; end
  def destroy_vote; @vote.destroy; end
  def change_vote; @vote.update(like: !@vote.like); end
end