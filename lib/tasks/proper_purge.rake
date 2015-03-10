
namespace :purge do

  def propose_meaning_removal(project, meaning, reason)
    if meaning.open_proposal_id
      if meaning.open_proposal.is_a? ProposeMeaningRemoval
        puts "dupe"
        return
      end
      meaning.open_proposal.note = "This was withdrawn, due to conflicting with automated tagging."
      meaning.open_proposal.withdraw!
    end
    project.add_target(meaning)
    puts meaning.word.name
    proposal = ProposeMeaningRemoval.new(meaning: meaning,
                word: meaning.word,
                reason: reason,
                project: project)
    proposal.save(validate: false)
    proposal
  end

  task :proper_nouns => :environment do
    p = Project.where(name: "Proper Noun Purge").first

    #Word.dated_meanings.each do |meaning|
    #  if meaning.word != nil
    #    removal = propose_meaning_removal(p, meaning, "This meaning has dates in it, and is considered likely to be a proper noun of some sort.")
    #    removal.approve!
    #  end
    #end
    Word.capitalized_nouns do |meaning|
      if meaning.word != nil
        propose_meaning_removal(p, meaning, "This meaning is from a capitalized word, and is considered likely to be a proper noun of some sort.")
      end
    end
  end

  task :shit_list => :environment do
    shit_list = [
      "ancient port",
      "United States",
      "born in",
      "city",
      "genus",
      "species",
      "unit of",
      "a republic",
      "years ago",
      "member of",
      "hypertension",
      "group of the",
      "degree in",
      "writer",
      "British",
      "English",
      "enzyme",
      "disease",
      "trade name",
      "agency",
      "a state in",
      "North America",
      "Africa",
      "doctor's degree",
      "tissue",
      "organization",
      "river",
      "mountain",
      "Mountain",
      "western",
      "eastern",
      "herb",
      "flowers",
      "division",
      "shrub",
      "fruit",
      "founded by",
      "system of beliefs",
      "tree",
      "the day",
      "the year",
      "town",
      "language",
      "philosopher",
      "America",
      "capital of",
      "national park",
      "battle",
      "sea",
      " war ",
      "name of",
      "an area",
      "resident of",
      "god",
      "physicist",
      "family of",
      "fungi",
      "fungus",
      "bacteria",
      "leader of",
      "wife of ",
      "native",
      "monetary unit",
      "a law",
      "physics",
      "missionary",
      "Christian",
      "writings of",
      "book that",
      "book of",
      "a book",
      "the largest",
      "Pacific Ocean",
      "island",
      "breed",
      "works"
    ]
    count = 0

    #user = User.where(username: "hcatlin").first
    limit = 1000
    limit = ENV["LIMIT"].to_i if ENV["LIMIT"]

    Project.last.proposals.open.each do |proposal|
      if proposal.meaning == nil
        puts proposal.inspect
        proposal.approve!
      else
        definition = proposal.meaning.def
        #puts "Definition! #{proposal.id}"
        has_shit_word = (shit_list.detect do |m|
          definition.include?(m)
        end)
        if has_shit_word
          proposal.note = "This was automatically closed, following the rules of the project that it was associated with."
          proposal.approve!
        end
      end
    end
    puts count

  end
end
