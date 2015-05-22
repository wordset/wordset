
namespace :data do
  task :run => [:clean, :update_labels]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :update_labels => :environment do
    Label.all.each &:save
  end

end
