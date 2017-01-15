class Users < Grape::API
  format :json

  resources :users do
    post '/' do
      @user = User.new params
      if @user.valid?
        @user.save
        "Account with #{@user.username} username was created!"
      else
        status 422
        @user.errors
      end
    end
  end
end