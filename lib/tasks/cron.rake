namespace :cron do
  task :run => :send_notifications do

  end

  task :send_notifications => :environment do
    Notification.send_emails
  end
end
