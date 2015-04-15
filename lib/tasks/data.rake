
namespace :data do
  task :run => [:clean,
                :create_speech_parts,
                :remove_entries,
                :fix_pos_like]

  task :clean => ["db:mongoid:remove_undefined_indexes", "db:mongoid:create_indexes"]

  task :rename => :environment do
    Entry.all.rename(:word_id => :wordset_id)
    Proposal.all.rename(:word_id => :wordset_id)
    Seq.all.rename(:word_id => :wordset_id)
    Proposal.where(_type: "ProposeNewWord").update_all(_type: "ProposeNewWordset")
    Wordset.update_all(lang_id: Lang.first.id)
  end

  task :create_speech_parts => :environment do
    SpeechPart.create(code: "adj", name: "adjective", lang: Lang.first)
    SpeechPart.create(code: "adv", name: "adverb", lang: Lang.first)
    SpeechPart.create(code: "verb", name: "verb", lang: Lang.first)
    SpeechPart.create(code: "noun", name: "noun", lang: Lang.first)
    SpeechPart.create(code: "conj", name: "conjunction", lang: Lang.first)
    SpeechPart.create(code: "pronoun", name: "pronoun", lang: Lang.first)
    SpeechPart.create(code: "prep", name: "preposition", lang: Lang.first)
    SpeechPart.create(code: "intj", name: "interjection", lang: Lang.first)
  end

  task :remove_entries => :environment do
    parts = {}
    SpeechPart.all.each do |part|
      parts[part.code] = part.id
    end
    Entry.all.each do |entry|
      Meaning.where(entry_id: entry.id).update_all(wordset_id: entry["wordset_id"], speech_part_id: parts[entry["pos"]])
    end
  end

  task :fix_pos_like => :environment do
    SpeechPart.all.each do |part|
      ProposeNewMeaning.where(pos: part.code).update_all(speech_part_id: part.id)
    end
  end

end
