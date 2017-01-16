class Sessions < Grape::API
  post '/sessions' do
    errors = { username: [], password: [] }
    errors[:username].push('Username is required') unless params[:username]
    errors[:password].push('Password is required') unless params[:password]

    if params[:username] && params[:password]
      @user = User.where(username: params[:username]).first
      errors[:username].push('User is not exist') unless @user

      if @user
        begin
          unless BCrypt::Password.new(@user.bcrypted_password) == params[:password]
            errors[:password].push('Wrong password')
          end
        rescue BCrypt::Errors::InvalidHash
          errors[:password].push('Password by server side has incorrect hash')
        end
      end
    end

    if errors[:username].length + errors[:password].length > 0
      status 422
      { errors: errors }
    else
      { access_token: @user.access_token }
    end
  end
end