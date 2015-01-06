class CreateWordMeanings < ActiveRecord::Migration
  def change
    create_table :word_meanings do |t|
      t.belongs_to :word_entry, index: true
      t.string :def
      t.string :grammaticalType

      t.timestamps null: false
    end
    add_foreign_key :word_meanings, :word_entries
  end
end
