
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
            word = Word.new(name: name)
            entries.each do |pos, meanings|
              we = WordEntry.new(pos: pos)
              we.meanings = meanings.map do |meaning|
                wm = WordMeaning.new(def: meaning['def'])
                if meaning['quotes'] != nil
                  wm.quotes = meaning['quotes'].map do |quote|
                    WordMeaningQuote.new(text: quote['text'])
                  end
                end
                wm
              end
              word.entries << we
            end
            #puts word.inspect
            word.save
            counter = counter + 1
            if counter % 1000 == 0
              puts "#{counter}"
              #exit
            end
          end
        rescue Exception => e
          puts e.inspect
        end
      end
    end
  end
end
