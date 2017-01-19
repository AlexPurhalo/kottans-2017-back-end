require 'helper_spec'

describe 'GET post comments' do
  before { Posts.before { env['api.tilt.root'] = 'app/views' } }
  def app; Posts; end

  before do
    User.create(username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK')
    Post.create(title: 'new post', description: 'some text')
    Category.create(name: 'fun')
    Category.last.add_post(Post.last)
    User.last.add_post(Post.last)
    Comment.create(body: 'Hello World')
    Post.last.add_comment(Comment.last)
    User.last.add_comment(Comment.last)
  end

  describe 'POSITIVE' do
    before { get '/posts/1/comments' }
    it 'shows the comments' do
      expect(last_response.body).to include(:body.to_json, 'Hello World')
    end
  end
end