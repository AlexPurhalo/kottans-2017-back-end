module Validation
  def auth_errors(user_id, access_token)
    errors = Array.new
    errors.push('User id is required, pass "X-User-Id" to request headers') unless user_id
    errors.push('Access token is required, pass "X-Access-Token" to headers') unless access_token
    errors.push('Personality confirmation is failed') if user_id && access_token != User[user_id].access_token
    errors
  end
  
  def post_post_errors(title, description, categories)
    errors = Array.new
    errors.push('Please provide both title and description') unless title && description
    errors.push('Title can not be empty') if title && title.length < 1
    errors.push('Description can not be empty') if description && description.length < 1
    errors.push('Post must has a category') unless categories
    errors.push('Pleas provide at last one category') if categories && categories.length < 1
    errors
  end
end