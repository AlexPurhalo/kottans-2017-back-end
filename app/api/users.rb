class Users < Grape::API
  resources :users do
    get '/', rabl: 'users/index' do
      @users = Array.new
      @users = User.all.each { |user| user.answers.length > 0 && @users.push(user) }
    end

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
        { access_token: @user.access_token, user_id: @user.id, username: @user.username }
      else
        status 422
        { errors: @user.errors }
      end
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


    github_id, github_avatar, name = auth_result['id'], auth_result['avatar_url'], auth_result['name']
    username, email = auth_result['login'], auth_result['email']

    user = User.where(github_id: github_id).first

    user.nil? && (user = User.create(
        github_id: github_id, username: username, github_avatar: github_avatar, name: name, email: email
    ))

    { access_token: user.access_token, user_id: user.id, username: username }
  end
end