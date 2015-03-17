module VotingSpecHelper

  def vote!(yae, flagged, trust_level)
    u = create(:user)
    allow(u).to receive(:trust_level) { trust_level }
    vote_as_user!(u, yae, flagged)
  end

  def vote_as_user!(user, yae, flagged)
    Vote.create(proposal: @proposal, user: user, yae: yae, flagged: flagged)
  end

  def yae!(trust_level = :fresh_face)
    vote!(true, false, trust_level)
  end

  def nay!(trust_level = :fresh_face)
    vote!(false, false, trust_level)
  end

  def flag!(trust_level = :fresh_face)
    vote!(false, true, trust_level)
  end
end
