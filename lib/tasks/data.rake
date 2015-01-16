
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
            word.entries = entries.map do |pos, meanings|
              {pos: pos,
              meanings: meanings}
            end
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

  task :create_suggestions => :environment do
    counter = 0
    Word.all.each do |word|
      counter += 1
      s = Suggestion.create(word: word, entries: word.entries, source: "Wordnet 3.0", status: "accepted")
      word.current = s
      word.save
      puts counter
    end
  end
end
