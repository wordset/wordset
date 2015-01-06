class Word < ActiveRecord::Base
  has_many :word_entries
  has_many :word_forms, :through => :word_entries
  has_many :word_meanings, :through => :word_entries
end
