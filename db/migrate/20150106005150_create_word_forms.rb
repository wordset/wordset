class CreateWordForms < ActiveRecord::Migration
  def change
    create_table :word_forms do |t|
      t.belongs_to :word_entry, index: true
      t.string :text
      t.string :grammaticalType

      t.timestamps null: false
    end
    add_foreign_key :word_forms, :word_entries
  end
end
