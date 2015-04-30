class LabelSerializer < BaseSerializer
  attributes :id, :name, :lang_id, :is_dialect, :for_seq, :for_meaning, :parent_id

  def lang_id
    object.lang.code
  end
end
