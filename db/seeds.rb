
Rails.configuration.cache_classes = true
#Rails.configuration.threadsafe!
Rails.configuration.allow_concurrency = true

Dir.glob(File.join(Rails.root, 'app', '{lib,app}', '*.rb')).each{|f| require f}

Rails.application.eager_load!

# We create three categories of users
# and high users will end up (semi-randomly) with higher
# status and votes levels. Low will have much less
users = {
  awesome: 1,
  high: 25,
  medium: 75,
  low: 75
}

users.each do |level_group, number_to_create|
  puts "Generating #{number_to_create} users at the #{level_group} level"
  users[level_group] = []
  number_to_create.times do |count|
    username = "#{level_group}#{count}"
    u = User.new(username: username,
                 email: "#{username}@test.com",
                 password: "testtest",
                 password_confirmation: "testtest",
                 accept_tos_at: Time.now,
                 accept_tos_ip: "127.0.0.1")
    # 1/3 of our users will be email-opt-in
    if rand(2) == 0
      u.email_opt_in_at = Time.now
      u.email_opt_in_ip = "127.0.0.1"
    end
    # raise an error if something goes wrong
    if !u.save
      puts u.errors.messages
      throw "User setup issue. Please file bug."
    end

    users[level_group] << u
  end
end
puts "Users all generated"

#-----------------------------------------------

#### NEW WORD PROPOSALS #####

# In order for the system to work correctly, we need *words* in it.
# And proposing new words is the way to do that. It's also a great
# way to get points and increase trust level. SO, by actually going
# through and creating proposals and then voting so that they get
# accepted, we can increase the diversity of our data pretty quickly.

puts "Creating New Word Proposals"

def create_proposal(user)
  meanings = Array.new(rand(3) + 1).map do
    EmbedNewWordMeaning.new(pos: Entry.pos.sample,
                            def: Faker::Lorem.sentence,
                            example: Faker::Hacker.say_something_smart,
                            reason: Faker::Hacker.say_something_smart)
  end

  p = ProposeNewWord.new(embed_new_word_meanings: meanings,
                         user: user,
                         reason: Faker::Hacker.say_something_smart)

  begin
    word_name = Faker::Lorem.words(3, true)[0..(rand(2)+1)].join(" ")
    p.name = word_name
    p.save!
  rescue
    puts p.errors.inspect
    if p.errors[:name].first == "already has a proposal open"
      puts "Already had #{word_name}"
      retry
    end
    puts p.user.errors.messages.inspect
    raise
  end
  return p
end

# This hash determines how many new word proposals to propose from
# each group, per-user
{awesome: 30, high: 5}.each do |level_group, number_of_new_word_proposals_per_user|
  users[level_group].each do |user|
    puts "Generating #{number_of_new_word_proposals_per_user} proposals for #{user.username}"
    user_id = user.id
    threads = []
    number_of_new_word_proposals_per_user.times do |proposal_number|
      threads << Thread.new {
        u = User.find(user_id)
        p = create_proposal(u)

        while p.open?
          p.votes.create(user: User.offset(rand(User.count)).first, yae: true)
        end

        puts "Took #{p.votes.count} votes to close ##{proposal_number}"
      }
    end
    threads.each { |thr| thr.join }
  end
end

50.times do
  Message.create(user: User.offset(rand(User.count)).first,
                 text: Faker::Hacker.say_something_smart)
end
