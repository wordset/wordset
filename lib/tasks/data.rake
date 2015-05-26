
namespace :data do
  task :run => [:clean, :project_slugs]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :project_slugs => :environment do
    {"54f4fd486461370003000000" => "parentheses",
      "54f8b2783537310003000000" => "proper-nouns",
      "550706373732370003000000" => "biology-terms"}.each do |id, slug|
        Project.find(id).update_attributes(slug: slug)
      end
  end

end
