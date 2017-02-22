class Posts < Grape::API
  resources :posts do
    get '/' do
      if params[:category]
        @category = Category.where(name: params[:category]).first

        if @category
          @posts = @category.posts.sort_by {|obj| obj.created_at}.reverse
          @posts.length < 1 && errors.push('Still does not contain any post :(')
        else
          errors.push('Category with this name does not exist')
        end
      else
        @posts = Post.order(Sequel.desc(:created_at))
      end

      errors.length < 1 ? (render rabl: 'posts/index') : ((status 422) && ({ errors: errors }))
    end

    post '/' do
      validation = ValidationService.new(
          AuthErrorsService.new(headers).validation_errors,
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

    put ':id/votes' do
      errors = Array.new

      user_id, jwt, post_id = request.headers['X-User-Id'], request.headers['X-Access-Token'], params[:id]

      (auth_errors = auth_errors(user_id, jwt)) && (errors.concat(auth_errors) unless auth_errors.empty?)

      if errors.length < 1
        @post, @user, @vote = Post[post_id], User[user_id], Vote.where(user_id: user_id, post_id: post_id).first

        if @vote.nil?
          (@vote = Vote.create(like: params[:like])) && (@vote.post = @post) && (@vote.user = @user) && @vote.save
        else
          @vote.like === params[:like] ? @vote.destroy : @vote.update(like: !@vote.like)
        end

        (@posts = Post.order(Sequel.desc(:created_at))) && (render rabl: 'posts/index')
      else
        (status 422) && ({errors: errors})
      end
    end

    get ':id/voting_answers', rabl: 'voting_answers/index' do
      @answers = Post[params[:id]].voting_answers
    end

    post ':post_id/variants/:variant_id/voting_answers/' do
      user_id, access_token, errors = request.headers['X-User-Id'], request.headers['X-Access-Token'], Array.new
      (auth_errors = auth_errors(user_id, access_token)) && (errors.concat(auth_errors) unless auth_errors.empty?)

      post_id, variant_id = params[:post_id], params[:variant_id]

      if errors.length < 1
        answer = VotingAnswer.create(post_id: post_id, variant_id: variant_id, user_id: user_id)

        User[user_id].add_voting_answer(answer)
        Post[post_id].add_voting_answer(answer)
        Variant[variant_id].add_voting_answer(answer)

        @answers = Post[post_id].voting_answers
        (@posts = Post.order(Sequel.desc(:created_at))) && (render rabl: 'posts/index')
      else
        (status 422) && ({ errors: errors })
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