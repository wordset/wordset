module LoginHelper
  def get_as(user, path, params = {}, options = {})
    options.merge!(auth_header_for(user))
    get(path, params, options)
  end

  def auth_header_for(user)
    {"Authorization" => "Bearer #{user.username}:#{user.auth_key}"}
  end
end
