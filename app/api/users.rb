class Users < Grape::API
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

    get '/:username/answers', rabl: 'answers/index' do
      @answers = User.where(username: params[:username]).first.answers
    end

    put '/:username/answers/:answer_id' do
      user_id, jwt, errors = request.headers['X-User-Id'], request.headers['X-Access-Token'], Array.new
      (auth_errors = auth_errors(user_id, jwt)) && (errors.concat(auth_errors) unless auth_errors.empty?)
      errors.push('Body for answer is required') unless params[:body]

      if errors.length < 1
        Answer[params[:answer_id]].update(body: params[:body])
        (@answers = User[user_id].answers) && (render rabl: 'answers/index')
      else
        (status 422) && ({ errors: errors })
      end
    end

    delete ':username/answers/:answer_id' do
      user_id, jwt, errors = request.headers['X-User-Id'], request.headers['X-Access-Token'], Array.new
      (auth_errors = auth_errors(user_id, jwt)) && (errors.concat(auth_errors) unless auth_errors.empty?)

      if errors.length < 1
        Answer[params[:answer_id]].destroy && (@answers = User[user_id].answers) && (render rabl: 'answers/index')
      else
        (status 422) && ({ errors: errors })
      end
    end

    post '/' do
      @user = User.new params

      if @user.valid?
        @user.save
        { access_token: @user.access_token, user_id: @user.id }
      else
        status 422
        { errors: @user.errors }
      end
    end
  end
end