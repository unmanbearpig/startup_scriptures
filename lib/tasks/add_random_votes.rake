namespace :scriptures do
  task :add_random_votes, [:range_from, :range_to] => [:environment] do |t, args|
    return puts('undefined range_from and range_to arguments') unless (args.has_key?(:range_from) && args.has_key?(:range_to))

    Link.find_each do |link|
      ActsAsVotable::Vote.where(votable: link, voter_type: FakeVoter).destroy_all
      FakeVoter.random_vote_for(link, args[:range_from].to_i..args[:range_to].to_i)
    end
  end
end
