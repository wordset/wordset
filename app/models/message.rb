class Message
  require 'uri'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Badger

  belongs_to :user
  index({user_id: 1, created_at: 1})
  index({created_at: -1})

  field :text, type: String

  badge do
    base_levels [1, 5, 25, 50, 100]
  end

  def self.parse(user, input, options = {})
    message = Message.new(user: user)
    args = input.split(" ")
    if input[0..0] == "/"
      action = args.first[1..-1]
      text = args[1..-1].join(" ")
      if action == "link" && text.length < 1
        text = options[:path]
      end
    else
      action = "say"
      text = input
    end

    model_for_action(action).new(
      user: user,
      text: text
    )
  end

  def self.model_for_action(action)
    case action
    when "say"
      MessageSay
    when "link"
      MessageLink
    when "me"
      MessageSelf
    else
      throw "No way, Jose!"
    end
  end

end
