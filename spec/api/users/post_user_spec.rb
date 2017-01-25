require 'helper_spec'

describe 'POST user' do
  def app; Users; end

  describe 'POSITIVE' do
    before do
      post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'
    end

    it 'has a 201 status' do
      expect(last_response.status).to eq(201)
    end

    context 'renders the following data' do
      it 'access token' do
        expect(last_response.body).to include(:access_token.to_json, User.first.access_token.to_json)
      end

      it 'user id' do
        expect(last_response.body).to include(:user_id.to_json, User.first.id.to_json)
      end
    end
  end

  describe 'NEGATIVE' do
    it 'has a 422 status' do
      post '/users'

      expect(last_response.status).to eq(422)
    end

    it 'generates the access token' do
      post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'

      expect(User.last.access_token).not_to eq(nil)
    end

    context 'shows appropriate message for' do
      it 'not provided username parameter' do
        post '/users', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'

        expect(last_response.body).to include('Username cannot be empty')
      end

      it 'empty username' do
        post '/users', username: '', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'

        expect(last_response.body).to include('Username cannot be empty')
      end

      it 'not provided password parameter' do
        post '/users', username: 'alex'

        expect(last_response.body).to include('Password can not be empty')
      end

      it 'empty password' do
        post '/users', username: 'alex', bcrypted_password: ''

        expect(last_response.body).to include('Password can not be empty')
      end

      it 'taken username' do
        post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'
        post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'

        expect(last_response.body).to include('This username is already taken')
      end
    end

    context 'does not show the following data about user:' do
      before do
        post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'
      end

      it 'password' do
        expect(last_response.body).not_to include(:bcrypted_password.to_json, '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK')
      end
    end
  end
end