namespace :admin do
  task :create => :environment do
    username = ENV["NAME"]
    if username.nil?
      throw "Must pass NAME=username"
    end
    email = username + "@wordset.org"
    password = ENV["PASSWORD"]
    if password.nil?
      throw "Must pass PASSWORD=password"
    end
    if password.length < 10
      throw "Password must be at least 10 characters"
    end
    Admin.create!(email: email, password: password, password_confirmation: password)
  end
end
