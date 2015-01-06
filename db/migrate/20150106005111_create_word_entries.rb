class CreateWordEntries < ActiveRecord::Migration
  def change
    create_table :word_entries do |t|
      t.string :pos
      t.belongs_to :word, index: true

      t.timestamps null: false
    end
    add_foreign_key :word_entries, :words
  end
end
