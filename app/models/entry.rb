# 
# class Entry
#   include Mongoid::Document
#   include PosLike
#   include SoftRemove
#
#   has_many :meanings,
#             autosave: true,
#             dependent: :destroy
#   belongs_to :wordset
#
#   validates :wordset,
#             :presence => true
#
#   validates :meanings,
#             :associated => true,
#             :length => { :minimum => 1 },
#             :on => :create
#
#   index({wordset_id: 1})
#   index({pos: 1})
#
#   set_callback :remove, :after do |entry|
#     if entry.wordset.entries.count == 0
#       entry.wordset.remove!
#     end
#   end
#
#   def self.pos
#     %w(adv adj verb noun prep pronoun conj intj)
#   end
# end
