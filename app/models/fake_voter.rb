class FakeVoter
  include ActiveModel::Model
  attr_accessor :id

  def self.random_vote_for votable, range
    vote_for votable, rand(range)
  end

  def self.vote_for votable, weight = 1
    votable.vote_by voter: self.new, vote_weight: weight
    votable.update_score if votable.respond_to? :update_score
  end

  def initialize id = rand(0..2**31)
    @id = id
  end

  def self.primary_key
    'id'
  end

  def [] key
    key.to_s == 'id' ? id : nil
  end

  def self.base_class
    return FakeVoter
  end

  def destroyed?
    false
  end

  def new_record?
    false
  end
end
