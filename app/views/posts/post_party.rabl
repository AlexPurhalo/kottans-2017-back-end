collection @party
  attributes :id
  child(:users) { attributes :id, :username }
