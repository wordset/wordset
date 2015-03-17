

namespace :trust do

  task :update_vote_points do
    Vote.all.each &:save
  end

  task :run => :environment do
    User.each &:save
  end
end
