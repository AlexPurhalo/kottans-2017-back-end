class Users < Grape::API
  format :json

  get '' do
    { message: 'hello world' }
  end
end