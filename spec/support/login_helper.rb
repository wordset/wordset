module LoginHelper
  def get_as(user, path, params = nil, options = {})
    do_as(:get, user, path, params, options)
  end

  def post_as(user, path, params = nil, options = {})
    do_as(:post, user, path, params, options)
  end

  def do_as(method, user, path, params = nil, options = {})
    if params.nil?
      params = options
      options = {}
    end
    options.merge!(auth_header_for(user))
    send(method, path, params, options)
  end

  def auth_header_for(user)
    {"Authorization" => "Bearer #{user.username}:#{user.auth_key}"}
  end
end
