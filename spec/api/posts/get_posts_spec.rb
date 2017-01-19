require 'helper_spec'

describe 'GET posts' do
  before { Posts.before { env['api.tilt.root'] = 'app/views' } }
  def app; Posts; end

  before do
    User.create(username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK')
    User.create(username: 'goblin', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK')
    Post.create(title: 'first post', description: 'some text')
    Post.create(title: 'new post', description: 'some text')
    Category.create(name: 'fun')
    Category.last.add_post(Post.first)
    Category.last.add_post(Post.last)
    User.last.add_post(Post.first)
    User.last.add_post(Post.last)
    Vote.create(like: true)
    Vote.create(like: false)
    User.first.add_vote(Vote[1])
    User.first.add_vote(Vote[2])
    Post.first.add_vote(Vote[1])
    Post.last.add_vote(Vote[2])
    User.last.add_vote(Vote[1])
    Comment.create(body: 'Hello World I am Alex')
    User.last.add_comment(Comment.last)
    Post.last.add_comment(Comment.last)
  end

  describe 'POSITIVE' do
    before { get '/posts' }

    it 'has a 200 status' do; expect(last_response.status).to eq(200); end

    context 'shows following attributes for records:' do
      it 'description' do; expect(last_response.body).to include(:description.to_json, 'some text'); end

      it 'title' do; expect(last_response.body).to include(:title.to_json, 'new post', 'first post'); end

      it 'created date' do
        expect(last_response.body).to include(:created_at.to_json,
                                              Post.last.created_at.to_json,
                                              Post.first.created_at.to_json)
      end

      it 'author name' do
        expect(last_response.body).to include(:user.to_json, :username.to_json, 'alex')
      end

      it 'category name' do
        expect(last_response.body).to include(:categories.to_json, :name.to_json, 'fun')
      end

      it 'votes' do
        expect(last_response.body).to include(:like.to_json, false.to_json, :votes.to_json)
      end

      it 'name of like (dislike) owner' do
        expect(last_response.body).to include({username: 'goblin'}.to_json)
      end

      context 'comments' do
        it 'create_date' do
          expect(last_response.body).to include(Comment.last.created_at.to_json)
        end

        it 'body' do
          expect(last_response.body).to include(:body.to_json 'Hello World I am Alex')
        end
      end
    end

    it 'shows the posts by chosen category' do
      Post.create(title: 'the last post', description: 'blablalbalba')
      Category.create(name: 'muhah')
      User.last.add_post(Post.last)
      Category.last.add_post(Post.last)

      get '/posts?category=fun'

      expect(last_response.body).not_to include('muhah')
    end
  end

  describe 'NEGATIVE' do
    it 'shows 422 status' do
      get '/posts?category=wtf'

      expect(last_response.status).to eq(422)
    end

    context 'shows error message about' do
      it 'note existing category' do
        get '/posts?category=wtf'

        expect(last_response.body).to include('Category with this name does not exist')
      end

      it 'category with the empty posts list' do
        Category.create(name: 'empty')
        get '/posts?category=empty'

        expect(last_response.body).to include('Still does not contain any post :(')
      end
    end
  end
end