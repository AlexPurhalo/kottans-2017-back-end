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
end


