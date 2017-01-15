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

    it 'shows the message that says that user was created' do
      expect(last_response.body).to  include('Account with alex username was created!')
    end
  end

  describe 'NEGATIVE' do
    it 'has a 422 status' do
      post '/users'

      expect(last_response.status).to eq(422)
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
  end
end