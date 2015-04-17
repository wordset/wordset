
namespace :data do
  task :run => [:clean,
                :empty_entries]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :empty_entries => :environment do
    Entry.delete_all
    Meaning.collection.find().update(
                        {'$unset' => {:entry_id => 1}},
                        :multi => true)
    ProposeNewMeaning.collection.find().update(
                        {'$unset' => {:pos => 1}},
                        :multi => true)
  end

end
