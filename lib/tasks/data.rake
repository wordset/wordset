
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
                  meaning.example = qdata
                end
              end
            end
            counter = counter + 1
            if counter % 1000 == 0
              puts "#{counter}"
            end
          end
        end
      end
    end
  end

  task :create_proposals => :environment do
    counter = 0
    Word.all.each do |word|
      s = ProposeNewWord.new(wordnet: true, state: "accepted", name: word.name, word: word)
      word.entries.all.each do |entry|
        entry.meanings.each do |meaning|
          counter += 1
          meaning = s.embed_new_word_meanings.build(pos: entry.pos, def: meaning.def, example: meaning.example)
          puts counter
        end
      end
      if !s.valid?
        s.embed_new_word_meanings.each do |m|
          puts m.inspect
          puts m.errors.messages
        end
      end

      s.save!
    end
  end
end
