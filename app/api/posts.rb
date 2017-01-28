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
        @posts = Post.order(Sequel.desc(:created_at))
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
        render rabl: 'posts/index'
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
        @posts = Post.order(Sequel.desc(:created_at))
        render rabl: 'posts/index'
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
        render rabl: 'posts/index'
      else
        status 422
        { errors: @post.errors }
      end
    end

    delete '/:id' do
      @post = Post[params[:id]]

      if @post
        @post.destroy
        @posts = Post.order(Sequel.desc(:created_at))
        render rabl: 'posts/index'
      else
        { errors: { post: ['Post is not exist or already was destroyed']}}
      end
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