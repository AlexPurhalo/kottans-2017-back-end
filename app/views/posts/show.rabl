object @post
attributes :id, :title, :description, :created_at
child(:user) { attributes :username }
child(:categories) { attributes :name }