class WordEntry < ActiveRecord::Base
  belongs_to :word
  has_many :word_forms
  has_many :word_meanings
end
