class Sessions < Grape::API
  post '/sessions' do
    errors = Array.new

    errors.push('Username is required') unless params[:username]
    errors.push('Password is required') unless params[:password]

    if params[:username] && params[:password]
      @user = User.where(username: params[:username]).first
      errors.push('User is not exist') unless @user

      if @user
        begin
          unless BCrypt::Password.new(@user.bcrypted_password) == params[:password]
            errors.push('Wrong password')
          end
        rescue BCrypt::Errors::InvalidHash
          errors.push('Password by server side has incorrect hash')
        end
      end
    end

    if errors.length + errors.length > 0
      (status 422) && ({ errors: errors })
    else
      { access_token: @user.access_token, user_id: @user.id, username: @user.username }
    end
  end

  # https://github.com/login/oauth/authorize?scope=user:email&client_id=4bc852f1f3bfb0234ccf
  get '/auth/github/callback' do
    result = RestClient.post('https://github.com/login/oauth/access_token',
                             {:client_id => '4bc852f1f3bfb0234ccf',
                              :client_secret => '1f8f68c7300e5553e35f3df2836c552ab807858d',
                              :code => params[:code]},
                             :accept => :json)

    access_token = JSON.parse(result)['access_token']

    auth_result = JSON.parse(RestClient.get('https://api.github.com/user',
                                            {:params => {:access_token => access_token}}))

    auth_result
  end
end