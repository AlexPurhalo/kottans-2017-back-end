class ProcessParty
  def initialize(params, headers)
    @post, @user = Post[params[:post_id]], User[headers['X-User-Id']]
    @party = @post.party
  end

  attr_accessor :party

  def process
    create_party unless party_exist?
    user_in_party? ? remove_user_from_party : add_user_to_party
  end

  def show; party; end

  private
  def party_exist?; party.nil? ? false : true; end

  def create_party; @party = Party.create(post_id: @post.id); end

  def user_in_party?
    in_party = false
    party.users.map { |user| user[:id] === @user.id.to_i && (in_party = true)}
    in_party
  end

  def remove_user_from_party;  party.remove_user(@user); end
  def add_user_to_party; party.add_user(@user); end
end