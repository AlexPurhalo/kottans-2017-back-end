require 'helper_spec'

describe 'POST vote for post' do
  before { Posts.before { env['api.tilt.root'] = 'app/views' } }
  def app; Posts; end
  #
  before do
    User.create(username: 'alex', bcrypted_password: '$2a$04$9pcNx.s8T4dcVsOZ0OEq.O4YP5Yr5zmmAa5pVmbaZrhA9YIKDUhq6')
    Post.create(title: 'some name', description: 'some text')
    User.first.add_post(Post.first)
  end

  let (:user) { User.where(username: 'alex').first }

  describe 'POSITIVE' do
    before do
      header 'X-User-Id', user.id
      header 'X-Access-Token', user.access_token
      put '/posts/1/votes', like: true
    end

    it 'has a 200 status' do; expect(last_response.status).to eq(200); end

    # it 'shows provided vote' do
    #   expect(last_response.body).to include(:votes.to_json, :like.to_json, true.to_json)
    # end
  end
end