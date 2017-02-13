collection @answers
attributes :id
child(:user) {
    attributes :id, :username
}