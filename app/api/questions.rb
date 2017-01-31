class Questions < Grape::API
  resources :questions do
    get '/', rabl: 'questions/index' do; @questions = Question.all; end # renders the questions list

    post '/' do
      errors = Array.new
      errors.push('Question can not be empty') unless params[:body]


      if errors.length < 1 # creates a new question and renders the questions list if passed data is valid
        (Question.create(body: params[:body])) && (@questions = Question.all) && (render rabl: 'questions/index')
      else
        { errors: errors }
      end
    end


    post '/:id/answers' do # .../questions/1/answers || ../users/alex/answers
      user_id, jwt, errors = request.headers['X-User-Id'], request.headers['X-Access-Token'], Array.new
      (auth_errors = auth_errors(user_id, jwt)) && (errors.concat(auth_errors) unless auth_errors.empty?)
      errors.push('Body for answer is required') unless params[:body]

      if errors.length < 1
        @answer = Answer.create(user_id: user_id, question_id: params[:id], body: params[:body])
        (@answers = User[request.headers['X-User-Id']].answers) && (render rabl: 'answers/index')
      end
    end
  end
end