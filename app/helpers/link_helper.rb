module LinkHelper
  def ui_link(path)
    url = bare_ui_link(path)
    if @notification
      api_link("notifications/#{@notification.id}/click?url=#{URI::escape(url)}")
    else
      url
    end
  end

  def bare_ui_link(path)
    File.join(ui_host, path)
  end

  def api_link(path)
    File.join(api_host, "/api/v1", path)
  end

  def api_host
    if Rails.env == "production"
      "https://api.wordset.org"
    else
      "http://localhost:3000"
    end
  end

  def ui_host
    if Rails.env == "production"
      "https://www.wordset.org"
    else
      "http://localhost:4200"
    end
  end
end
