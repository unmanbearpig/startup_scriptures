class AddScoreToLinks < ActiveRecord::Migration
  def up
    add_column :links, :score, :integer
    Link.find_each { |link| link.update_score }
  end

  def down
    remove_column :links, :score, :integer
  end

end
