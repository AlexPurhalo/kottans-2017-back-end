collection @comments
  attributes :id, :body, :created_at
  child(:user) { attributes :username }
