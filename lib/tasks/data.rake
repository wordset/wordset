
namespace :data do
  task :run => [:clean, :make_labels]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :make_labels => :environment do
    Label.destroy_all

    en = Lang.last
    informal = en.labels.create(name: "informal", for_seq: false)
    en.labels.create(name: "slang", parent: informal, for_seq: false)
    en.labels.create(name: "offensive", parent: informal, for_seq: false)
    en.labels.create(name: "archaic")
    en.labels.create(name: "idiom", for_seq: false)
    en.labels.create(name: "formal")
    technical = en.labels.create(name: "technical")
    en.labels.create(name: "medical", parent: technical)
    en.labels.create(name: "legal", parent: technical)
    en.labels.create(name: "scientific", parent: technical)

    dialects = {
      "American" => [ "US", "Canada", "AAVE"],
      "British" => [ "UK", "Ireland", "South Africa", "India", "Australia", "New Zealand"]
    }

    dialects.each do |major, minors|
      dialect = en.labels.create(name: major, is_dialect: true)
      minors.each do |minor|
        en.labels.create(name: minor, is_dialect: true, parent: dialect)
      end
    end
  end

end
