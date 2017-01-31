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

    post '/:username/answers' do
      user_id = request.headers['X-User-Id']
      question_id = Question[params[:question_id]]

      @answer = Answer.create(user_id: user_id, body: params[:body], question_id: question_id)
      @answers = User[user_id].answers

      render rabl: 'answers/index'
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