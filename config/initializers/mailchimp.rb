if Rails.env == "production"
  Gibbon::API.api_key = ENV["MAILCHIMP_KEY"]
  Gibbon::API.timeout = 15
  Gibbon::API.throws_exceptions = false

  Mailchimp = Gibbon::API.new()
  WordsetListId = Mailchimp.lists.list({:filters => {:list_name => "Wordset"}})["data"].first["id"]
end
