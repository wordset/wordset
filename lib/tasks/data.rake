
namespace :data do
  task :run => [:clean,
                :seqs,
                :clean_words,
                :lang_proposals]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :seqs => :environment do
    l = Lang.create(code: "en", name: "English")
    count = Word.count
    Word.each do |word|
      count -= 1
      puts count
      word.seqs.create(text: word["name"], lang: l)
    end
  end

  task :clean_words => :environment do
    Word.update_all(name: nil, alpha: nil, word_length: nil)
  end

  task :lang_proposals => :environment do
    l = Lang.first
    Proposal.update_all(lang_id: l.id)
  end

end
