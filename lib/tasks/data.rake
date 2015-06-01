
namespace :data do
  task :run => [:clean, :add_lang_code]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :add_lang_code => :environment do
    lang = Lang.first
    [Seq, Project, Proposal, Post, Label, Message].each do |klass|
      klass.update_all(lang_code: "en", lang_id: lang.id)
    end
  end

end
