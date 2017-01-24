class Posts < Grape::API
  resources :posts do
    errors = Array.new

    get '/' do
      if params[:category]
        @category = Category.where(name: params[:category]).first

        if @category
          @posts = @category.posts
          @posts.length < 1 && errors.push('Still does not contain any post :(')
        else
          errors.push('Category with this name does not exist')
        end
      else
        @posts = Post.order(:created_at)
      end

      if errors.length < 1
        render rabl: 'posts/index'
      else
        status 422
        { errors: errors }
      end
    end

    get '/:id' do
      @post = Post[params[:id]]

      if @post
        render rabl: 'posts/show'
      else
        { errors: { post: ['Post with this id does niot exist']}}
      end
    end

    post '/' do
      errors = Array.new

      post_errors = post_post_errors(params[:title], params[:description], params[:categories])
      errors.concat(post_errors) unless post_errors.empty?

      auth_errors = auth_errors(request.headers['X-User-Id'], request.headers['X-Access-Token'])
      errors.concat(auth_errors) unless auth_errors.empty?

      if errors.length < 1
        @post = Post.create(title: params[:title], description: params[:description]) # creates a new post

        @user = User[request.headers['X-User-Id']] # finds a post owner
        @user.add_post(@post) # pushes a recently created post to founded user

        params[:categories].each do |category_name|
          category = Category.where(name: category_name).first
          category.nil? && (category = Category.create(name: category_name))
          category.add_post(@post)
        end

        render rabl: 'posts/show'
      else
        status 422
        { errors: errors }
      end
    end

    put '/:id' do
      @post = Post[params[:id]]

      params[:title] && (@post.title = params[:title])
      params[:description] && (@post.description = params[:description])

      if @post.valid? || @post.errors[:post]
        @post.save
        render rabl: 'posts/show'
      else
        status 422
        { errors: @post.errors }
      end
    end

    delete '/:id' do
      @post = Post[params[:id]]

      if @post
        @post.destroy
        @posts = Post.order(:created_at)
        render rabl: 'posts/index'
      else
        { errors: { post: ['Post is not exist or already was destroyed']}}
      end
    end

    put ':id/votes' do
      errors = Array.new


      unless request.headers['X-User-Id']
        errors.push('Please provide user id, "X-User-Id" to the request headers')
      end

      unless request.headers['X-Access-Token']
        errors.push('Please provide access token, "X-Access-Token" to header')
      end

      if request.headers['X-User-Id'] && request.headers['X-Access-Token'] != User[request.headers['X-User-Id']].access_token
        errors.push('Personality confirmation is failed')
      end

      @post, @user = Post[params[:id]], User[request.headers['X-User-Id']]

      @vote = Vote.where(user_id: request.headers['X-User-Id'], post_id: params[:id]).first

      if errors.length < 1
        if @vote
          if @vote.like === params[:like]
            @vote.destroy
          else
            @vote.like = params[:like]
            @vote.save
          end
        else
          @vote = Vote.create(like: params[:like])
          @vote.post = @post
          @vote.user = @user
          @vote.save
        end
      end

      if errors.length < 1
        render rabl: 'posts/show'
      else
        status 422
        {errors: errors}
      end
    end

    get ':id/comments', rabl: 'posts/comments' do
      @post = Post[params[:id]]
      @comments = @post.comments
    end

    post ':id/comments' do
      errors = Array.new

      if params[:body].nil? || params[:body].length < 1
        errors.push('Please provide some content for to post a comment')
      end

      unless request.headers['X-User-Id']
        errors.push('Please provide id of post owner, "X-User-Id" to request headers')
      end

      unless request.headers['X-Access-Token']
        errors.push('Please provide access token, "X-Access-Token" to header')
      end

      if request.headers['X-User-Id'] && request.headers['X-Access-Token'] != User[request.headers['X-User-Id']].access_token
        errors.push('Personality confirmation is failed')
      end

      if errors.length < 1
        @post = Post[params[:id]]
        @user = User[request.headers['X-User-Id']]
        @comment = Comment.create(body: params[:body])
        @user.add_comment(@comment)
        @post.add_comment(@comment)
        @post.comments.count
      else
        { errors: errors }
      end
    end
  end
end