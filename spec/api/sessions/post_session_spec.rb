require 'helper_spec'

describe 'POST sessions' do
  before { Users.before { env['api.tilt.root'] = 'app/views' } }

  before do
    post '/users', username: 'alex', bcrypted_password: '$2a$04$9pcNx.s8T4dcVsOZ0OEq.O4YP5Yr5zmmAa5pVmbaZrhA9YIKDUhq6'
  end


  describe 'POSITIVE' do
    context 'for user with the correct data ' do
      before { post '/sessions', username: 'alex', password: 'abaglamaga' }

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
  end

  describe 'NEGATIVE' do
    context 'for user with incorrect data' do
      it 'has a 404 status' do
        post '/sessions'

        expect(last_response.status).to eq(422)
      end

      context 'renders message about the' do
        it 'empty username parameter' do
          post '/sessions', password: 'abaglamaga'

          expect(last_response.body).to include('Username is required')
        end

        it 'empty password parameter' do
          post '/sessions', username: 'alex'

          expect(last_response.body).to include('Password is required')
        end

        it 'both empty username and password' do
          post '/sessions'

          expect(last_response.body).to include('Password is required', 'Username is required')
        end

        it 'about not existing user' do
          post '/sessions', username: 'lol', password: '12313'
        end

        it 'wrong password' do
          post '/sessions', username: 'alex', password: '123123'

          expect(last_response.body).to include('Wrong password')
        end

        it 'invalid hash' do
          user = User.first
          user.bcrypted_password = 'new-hash'
          user.save

          post '/sessions', username: 'alex', password: 'abaglamaga'

          expect(last_response.body).to include('Password by server side has incorrect hash')
        end
      end
    end
  end
end