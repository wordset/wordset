namespace :cron do
  task :run => [:send_notifications] do
    puts "RAN REGULAR CRON JOB"
  end

  task :daily => ["sitemap:refresh", :build_wordlist_index] do
    puts "RAN DAILY CRON JOB"
  end

  task :send_notifications => :environment do
    Notification.send_emails
  end

  task :build_wordlist_index => :environment do

    
  end
end
