Gibbon::API.api_key = "6135ff5e70091b8c59b642cf265a22b6-us3"
Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = false

Mailchimp = Gibbon::API.new()
WordsetListId = Mailchimp.lists.list({:filters => {:list_name => "Wordset"}})["data"].first["id"]
