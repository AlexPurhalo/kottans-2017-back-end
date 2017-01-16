class Posts < Grape::API
  resources :posts do
    get '/', rabl: 'posts/index' do
      @posts = Post.order(:created_at)
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

      unless params[:title] || params[:description]
        errors.push('Please provide title or description')
      end

      if params[:title] && params[:title].length < 1
        errors.push('Title can not be empty')
      end

      if params[:description] && params[:description].length < 1
        errors.push('Description can not be empty')
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

      unless request.headers['X-Category-Name']
        errors.push('Please provide category for this post')
      end

      if errors.length < 1
        @post = Post.create(title: params[:title], description: params[:description])

        @user = User[request.headers['X-User-Id']]
        @user.add_post(@post)

        @category = Category.where(name: request.headers['X-Category-Name']).first
        @category.nil? && (@category = Category.create(name: request.headers['X-Category-Name']))
        @category.add_post(@post)

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
  end
end