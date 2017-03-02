node(:meta) { |m| {
        total_objects: Post.count,
        page_num: params[:page],
        page_size: params[:size]
    }
}

child (@posts) {
    attributes :id, :title, :description, :created_at, :with_party, :with_voting
    child(:user) { attributes :username }
    child(:categories) { attributes :name }
    child(:votes) {
        attributes :like
        child(:user) { attributes :username }
    }
    child(:comments) {
        attributes :id, :body, :created_at
        child(:user) { attributes :username }
    }
    child(:party) {
        attributes :id
        child(:users) { attributes :id, :username }
    }

    child(:variants) {
        attributes :id, :body
        child(:voting_answers, :root => "voting_answers") {
            attributes :id
            child(:user) { attributes :username, :id }
        }
    }

    child(:voting_answers, :root => "voting_answers") {
        attributes :id
        child(:user) { attributes :username, :id }
    }
}

