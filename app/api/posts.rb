class Posts < Grape::API
  get 'posts/' do
    validation = ValidationService.new(PostsReadingErrorsService.new(params).validation_errors)

    validation.without_errors? ?
        (@posts = ReadPostsService.new(params).show_posts) && (render rabl: 'posts/index') :
        render_errors(validation.errors)
  end

  post 'posts/' do
    validation = ValidationService.new(AuthErrorsService.new(request.headers).validation_errors,
                                       PostCreatingErrorsService.new(params).validation_errors)

    for_paginating = { category: 'Events', page: 1, size: 5}

    validation.without_errors? ?
        CreatePostService.new(params, request.headers['X-User-Id']).show_post &&
            (@posts = ReadPostsService.new(for_paginating).show_posts) && (render rabl: 'posts/index') :
        render_errors(validation.errors)
  end

  put 'posts/:id' do
    update_by_params((@post = Post[params[:id]]), params) && (render rabl: 'posts/show')
  end

  put 'posts/:post_id/votes' do
    validation = ValidationService.new(AuthErrorsService.new(request.headers).validation_errors,
                                       PostPreferencesErrorsService.new(params).validation_errors)
    validation.without_errors? ?
        (pref = AddPreference.new(params, request.headers)) && pref.process_vote && render_post_votes(pref.show) :
        render_errors(validation.errors)
  end

  post 'posts/:post_id/variants/:variant_id/voting_answers/' do
    validation = ValidationService.new(AuthErrorsService.new(request.headers).validation_errors,
                                       AddVotingAnswersErrorsService.new(params).validation_errors)
    validation.without_errors? ?
        (voting = AddVotingAnswer.new(params, request.headers)) && voting.process && (render_voting(voting.show)) :
        render_errors(validation.errors)
  end

  post 'posts/:post_id/party' do
    validation = ValidationService.new(AuthErrorsService.new(request.headers).validation_errors,
                                       PersonAddingToPartyErrors.new(params).validation_errors)
    validation.without_errors? ?
        (party = ProcessParty.new(params, request.headers)) && party.process && render_post_party(party.show) :
        render_errors(validation.errors)
  end

  post 'posts/:post_id/comments' do
    validation = ValidationService.new(AuthErrorsService.new(request.headers).validation_errors,
                                       CreateCommentErrors.new(params).validation_errors)

    validation.without_errors? ?
        (@comments = CreateComment.new(params, request.headers).show_comments) && (render rabl: 'posts/post_comments') :
        validation.errors
  end

  get 'posts/:post_id' do
    validation = ValidationService.new(ShowPostErrors.new(params).validation_errors)
    validation.errors
    validation.without_errors? ?
        ((@post = ShowPost.new(params).show_post) && (render rabl: 'posts/show_post')) : (validation.errors)
  end
end