module Ranks
  extend ActiveSupport::Concern

  RANKS = {
    user: {
      name: "User",
      vote_value: 1,
      min_trust: 0
    },
    contributor: {
      name: "Contributor",
      vote_value: 10,
      min_trust: 20
    },
    junior_editor: {
      name: "Junior Editor",
      vote_value: 20,
      min_trust: 50
    },
    editor: {
      name: "Editor",
      vote_value: 35,
      min_trust: 100
    },
    senior_editor: {
      name: "Senior Editor",
      vote_value: 50,
      min_trust: 500
    },
    admin: {
      name: "Admin",
      vote_value: 75,
      min_trust: nil
    }
  }

  def rank
    RANKS[rank_id]
  end

  def admin?
    (username == "hcatlin") || (username == "malrase")
  end

  def rank_id
    if admin?
      return :admin
    elsif self.points > 5
      return :contributor
    else
      return :user
    end
  end

  def vote_value
    rank[:vote_value]
  end

end
