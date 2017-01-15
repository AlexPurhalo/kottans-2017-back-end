require 'helper_spec'

describe 'GET user' do
  before { Users.before { env['api.tilt.root'] = 'app/views' } }
  def app; Users; end

  before do
    post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'
    get '/users/1'
  end

  describe 'POSITIVE' do
    it 'has a 200 status' do
      expect(last_response.status).to eq(200)
    end

    context 'shows the following data about user: ' do
      it 'id' do
        expect(last_response.body).to include(:id.to_json, 1.to_json)
      end

      it 'username' do
        expect(last_response.body).to include(:username.to_json, 'alex')
      end
    end
  end

  describe 'NEGATIVE' do
    context 'does not show user' do
      it 'bcrypted password' do
        expect(last_response.body).not_to include(:bcrypted_password.to_json, '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK')
      end
    end

    context 'for not existing user' do
      before { get '/users/2' }

      it 'has a 404 status' do
        expect(last_response.status).to eq(404)
      end

      it 'shows the appropriate message' do
        expect(last_response.body).to include('User was not founded')
      end
    end
  end
end