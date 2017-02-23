collection @voting_answers
attributes :id
child(:user) { attributes :username, :id }
