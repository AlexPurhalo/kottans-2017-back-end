collection @posts
attributes :id, :title, :description, :created_at
child(:user) { attributes :username }
child(:categories) { attributes :name }
child(:votes) {
    attributes :like
    child(:user) { attributes :username }
}