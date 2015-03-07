
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
      "America"
    ]
    count = 0

    user = User.where(username: "hcatlin").first

    Project.last.proposals.open.where(tally: 0).each do |proposal|
      definition = proposal.meaning.def
      #puts "Definition! #{proposal.id}"
      has_shit_word = (shit_list.detect do |m|
        definition.include?(m)
      end)
      if has_shit_word
        count += 1
        puts count
        #puts "shit: #{proposal.word_name} #{proposal.meaning.def}"
        v = proposal.votes.build(yae: true,
                                 flagged: false,
                                 skip: false)
        v.user = user
        if v.save == false
          puts "!!!!!!!!!!!!!!!!!ERROR #{proposal.word_name}"
          puts v.errors.messages.inspect
        else
          proposal.pushUpdate!
        end

      else
        #puts "okay: #{proposal.word_name} #{proposal.meaning.def}"
      end
    end
    puts count

  end
end
