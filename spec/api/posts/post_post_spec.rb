require 'helper_spec'

describe 'POST post' do
  before { Posts.before { env['api.tilt.root'] = 'app/views' } }
  def app; Posts; end

  before do
    User.create(username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK')
    Category.create(name: 'fun')
  end

  let (:user) { User.where(username: 'alex').first }
  let (:category) { Category.where(name: 'fun').first }

  describe 'POSITIVE' do
    before do
      header 'X-User-Id', user.id
      header 'X-Access-Token', user.access_token
      post '/posts',
           title: 'new post',
           description: 'some text',
           categories: ['fun', 'lol'],
           with_party: false,
           with_voting: false
    end

    it 'has a 201 status' do; expect(last_response.status).to eq(201); end
    it 'pushes post to other' do; expect(Post.count).to eq(1); end

    context 'shows following attributes:' do
      it 'description' do; expect(last_response.body).to include(:description.to_json, 'some text'); end

      it 'title' do; expect(last_response.body).to include(:title.to_json, 'new post'); end

      it 'created date' do
        expect(last_response.body).to include(:created_at.to_json, Post.last.created_at.to_json)
      end

      it 'author username' do
        expect(last_response.body).to include(:user.to_json, :username.to_json, 'alex')
      end

      it 'category name' do
        expect(last_response.body).to include(:categories.to_json, :name.to_json, 'fun')
      end
    end
  end
end