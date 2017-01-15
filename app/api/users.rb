class Users < Grape::API
  format :json
  formatter :json, Grape::Formatter::Rabl

  resources :users do
    get '/', rabl: 'users/index' do @users = User.all; end

    get '/:id' do
      @user = User[params[:id]]

      if @user
        render rabl: 'users/show'
      else
        status 404
        { errors: { user: 'User was not founded' } }
      end
    end

    post '/' do
      @user = User.new params

      if @user.valid?
        @user.save
        render rabl: 'users/show'
      else
        status 422
        { errors: @user.errors }
      end
    end
  end
end