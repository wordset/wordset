
namespace :data do
  task :run => [:clean, :gendered_project]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :gendered_project => :environment do
    ProjectTarget.where(state: "invalid").update_all(state: "marked_invalid")
    project = Project.create(name: "Sexism Purge", slug: "sexism-purge",
            description: "Remove gendered pronouns from example sentences",
            long_description: "<p>Wordset inherited a lot of example sentences that break our rules for what a good example sentence should be. Help us clear out the gendered example sentences and make Wordset the first gender neutral dictionary!</p>",
            rules: "Replace he/she/him/her/his/hers/girl/boy/man/woman with I/they/we/you/it or sentences in the passive voice.")
    Meaning.where(:example => /\b([s]?he|him|her|woman|girl|man|boy|his|hers) /i, :open_proposal_id=> nil).each do |meaning|
      puts meaning.example
      project.add_target(meaning)
    end
  end

end
