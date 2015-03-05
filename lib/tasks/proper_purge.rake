
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
    p = Project.qhwew(name: "Proper Noun Purge").first

    Word.dated_meanings.each do |meaning|
      if meaning.word != nil
        removal = propose_meaning_removal(p, meaning, "This meaning has dates in it, and is considered likely to be a proper noun of some sort.")
        removal.approve!
      end
    end
    Word.capitalized_nouns do |meaning|
      if meaning.word != nil
        propose_meaning_removal(p, meaning, "This meaning is from a capitalized word, and is considered likely to be a proper noun of some sort.")
      end
    end
  end
end
