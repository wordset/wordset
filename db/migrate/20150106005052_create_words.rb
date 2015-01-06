class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :lemma

      t.timestamps null: false
    end
  end
end
