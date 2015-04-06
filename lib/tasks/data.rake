
namespace :data do
  task :run => [:clean,
                :rename

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :rename => :environment do
    Entry.all.rename(:word_id, :wordset_id)
    Proposal.all.rename(:word_id, :wordset_id)
    Seq.all.rename(:word_id, :wordset_id)
    Proposal.where(type: "ProposeNewWord").update_all(type: "ProposeNewWordSet")
  end

end
