module Validation
  def update_by_params(record, params); params.each { |param, val| param != 'id' && record.update("#{param}": val)}; end

  def render_posts_list; (@posts = Post.order(Sequel.desc(:created_at))) && (render rabl: 'posts/index'); end

  def render_errors(validation_errors); (status 422) && { errors: validation_errors }; end

  def render_post_votes(votes_list); (@votes = votes_list) &&  (render rabl: 'posts/post_votes'); end

  def render_post_party(party); (@party = party) && (render rabl: 'posts/post_party'); end

  def render_voting(answers); (@voting_answers = answers) && (render rabl: 'posts/voting_answers'); end
end