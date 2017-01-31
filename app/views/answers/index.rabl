collection @answers
attributes :id, :body
child(:user) {
    attributes :id, :username
}
child(:question) {
    attributes :id, :body
}