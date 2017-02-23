class Posts < Grape::API
  resources :posts do
    get '/' do
      validation = ValidationService.new(PostsReadingErrorsService.new(params).validation_errors)

      validation.without_errors? ?
          (@posts = ReadPostsService.new(params).show_posts) && (render rabl: 'posts/index') :
          render_errors(validation.errors)
    end

    post '/' do
      validation = ValidationService.new(
          AuthErrorsService.new(request.headers).validation_errors,
          PostCreatingErrorsService.new(params).validation_errors
      )

      validation.without_errors? ?
          CreatePostService.new(params, request.headers['X-User-Id']).show_post && render_posts_list :
          render_errors(validation.errors)
    end

    put '/:id' do
      update_by_params((@post = Post[params[:id]]), params) && (render rabl: 'posts/show')
    end

    delete '/:id' do
      @post = Post[params[:id]]

      @post ?
          (@post.destroy) && (@posts = Post.order(Sequel.desc(:created_at))) && (render rabl: 'posts/index') :
          { errors: { post: ['Post is not exist or already was destroyed']}}
    end

    put ':post_id/votes' do
      validation = ValidationService.new(
          AuthErrorsService.new(request.headers).validation_errors,
          PostPreferencesErrorsService.new(params).validation_errors
      )

      if validation.without_errors?
        preferences = AddPreferenceService.new(params, request.headers)
        preferences.process_vote && render_post_votes(preferences.show_votes)
      else
        render_errors(validation.errors)
      end
    end

    get ':id/voting_answers', rabl: 'voting_answers/index' do
      @answers = Post[params[:id]].voting_answers
    end

    post ':post_id/variants/:variant_id/voting_answers/' do
      validation = ValidationService.new(
          AuthErrorsService.new(request.headers).validation_errors,
          AddVotingAnswersErrorsService.new(params).validation_errors
      )

      if validation.without_errors?
        voting = AddVotingAnswersService.new(params, request.headers)
        voting.process_answer && (@voting_answers = voting.show_answers) && (render rabl: 'posts/voting_answers')
      else
        render_errors(validation.errors)
      end
    end

    get ':id/comments', rabl: 'posts/index' do
      @post = Post[params[:id]]
      @comments = @post.comments
    end

    post ':id/party' do
      post_id, user_id, access_token = params[:id], request.headers['X-User-Id'], request.headers['X-Access-Token']

      (auth_errors = auth_errors(user_id, access_token)) && (errors.concat(auth_errors) unless auth_errors.empty?)

      if errors.length < 1
        @post, @user = Post[post_id], User[user_id]
        @party = @post.party
        @party.nil? && (@party = Party.create(post_id: @post.id))

        user_exist = false
        @party.users.map { |user| user[:id] == user_id.to_i && (user_exist = true)}

        user_exist === true && @party.remove_user(@user)
        user_exist === false && @party.add_user(@user)

        (@posts = Post.order(Sequel.desc(:created_at))) && (render rabl: 'posts/index')
      else
        (status 422) && ({ errors: errors })
      end
    end

    post ':id/comments' do
      errors = Array.new

      if params[:body].nil? || params[:body].length < 1
        errors.push('Please provide some content for to post a comment')
      end

      auth_errors = auth_errors(request.headers['X-User-Id'], request.headers['X-Access-Token'])
      errors.concat(auth_errors) unless auth_errors.empty?

      if errors.length < 1
        @post, @user = Post[params[:id]], User[request.headers['X-User-Id']]
        (@comment = Comment.create(body: params[:body])) && @user.add_comment(@comment) && @post.add_comment(@comment)
        (@posts = Post.order(Sequel.desc(:created_at))) && (render rabl: 'posts/index')
      else
        (status 422) && ({ errors: errors })
      end
    end
  end
end