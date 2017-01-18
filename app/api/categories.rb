class Categories < Grape::API
  resources :categories do
    get '/', rabl: 'categories/index' do
      @categories = Category.all
    end
  end
end