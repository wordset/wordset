
namespace :data do
  task :load => :environment do

    counter = 0
    if !File.exists?("db/wordnet.json")
      puts "UNZIP THE JSON, IDJIOT"
    else
      Word.destroy_all
      File.open("db/wordnet.json").each_line do |line|
        begin
          data = JSON.parse(line)
          data.each do |name, entries|
            word = Word.create(name: name)
            entries.each do |pos, meanings|
              entry = Entry.create(pos: pos, word: word)
              meanings.each do |data|
                meaning = Meaning.create(def: data["def"], entry: entry)
                (data["quotes"] || []).each do |qdata|
                  Quote.create(text: qdata["text"], source: "Wordnet 3.0", meaning: meaning)
                end
              end
            end
            counter = counter + 1
            if counter % 1000 == 0
              puts "#{counter}"
              #exit
            end
          end
        #rescue Exception => e
        #  puts e.inspect
        end
      end
    end
  end

  task :create_suggestions => :environment do
    counter = 0
    Word.all.each do |word|
      word.entries.all.each do |entry|
        entry.meanings.each do |meaning|
          counter += 1
          s = Suggestion.create(word: word, action: "create", wordnet: true, target: meaning, state: "accepted", delta: {def: meaning.def, example: meaning.example})
          s.save!
          puts counter
        end
      end
    end
  end
end
