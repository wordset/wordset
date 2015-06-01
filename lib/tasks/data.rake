
namespace :data do
  task :run => [:clean, :add_lang_to_posts]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :add_lang_to_posts => :environment do
    lang = Lang.first
    Project.update_all(lang_id: lang.id)
    Post.update_all(lang_id: lang.id)
    lang.featured_project = Project.where(slug: "gender-neutral-project").first
    lang.save
  end

end
