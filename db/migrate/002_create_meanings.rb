class CreateMeanings < ActiveRecord::Migration
  def self.up
    create_table :meanings do |t|
      t.string :pos
      t.string :def
      t.belongs_to :word
      t.timestamps
    end
  end

  def self.down
    drop_table :meanings
  end
end
