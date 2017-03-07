# require 'helper_spec'
#
# describe 'GET users' do
#   before { Users.before { env['api.tilt.root'] = 'app/views' } }
#   def app; Users; end
#
#   before do
#     post '/users', username: 'alex', bcrypted_password: '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK'
#     post '/users', username: 'motherfucker228', bcrypted_password: '$2a$04$n8DQE8uvTKBNGDRcFQVxlOKgTVb3x6Y4.UHbWhW8WYAn.Zp6kp2zy'
#     get '/users'
#   end
#
#   describe 'POSITIVE' do
#     it 'has a 200 status' do
#       expect(last_response.status).to eq(200)
#     end
#
#     context 'shows the following data for users:' do
#       it 'usernames' do
#         expect(last_response.body).to include(:username.to_json, 'alex', 'motherfucker228')
#       end
#
#       it 'ids' do
#         expect(last_response.body).to include(:id.to_json, 1.to_json, 2.to_json)
#       end
#     end
#
#   end
#
#   describe 'NEGATIVE' do
#     context 'does not show users' do
#       it 'passwords' do
#         expect(last_response.body).not_to include(:bcrypted_password.to_json,
#                                                   '$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK',
#                                                   '$2a$04$n8DQE8uvTKBNGDRcFQVxlOKgTVb3x6Y4.UHbWhW8WYAn.Zp6kp2zy')
#       end
#
#       it 'access tokens' do
#         expect(last_response.body).not_to include(:access_token.to_json)
#       end
#     end
#   end
# end