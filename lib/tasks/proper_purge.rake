
namespace :purge do

  def propose_meaning_removal(project, meaning, reason)
    if meaning.open_proposal
      if meaning.open_proposal.is_a? ProposeMeaningRemoval
        puts "dupe"
        return
      end
      meaning.open_proposal.note = "This was withdrawn, due to conflicting with automated tagging."
      meaning.open_proposal.withdraw!
    end
    project.add_target(meaning)
    puts meaning.word.name
    ProposeMeaningRemoval.create(meaning: meaning,
              word: meaning.word,
              reason: reason,
              project: project)

  end

  task :proper_nouns => :environment do
    p = Project.create(name: "Proper Noun Purge",
                       description: "We are getting rid of all of the proper nouns that came into the system via Wordnet. We don't feel most of these are about language, but about reference, generally. The proposals have been automatically generated.")

    Word.dated_meanings.each do |meaning|
      if meaning.word != nil
        removal = propose_meaning_removal(p, meaning, "This meaning has dates in it, and is considered likely to be a proper noun of some sort.")
        removal.approve!
      end
    end
    Word.capitalized_nouns do |meaning|
      if meaning.word != nil
        propose_meaning_removal(p, meaning, "This meaning has dates in it, and is considered likely to be a proper noun of some sort.")
      end
    end
  end
end
