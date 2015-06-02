module BelongsToLang
  extend ActiveSupport::Concern

  included do |base|
    base.belongs_to :lang
    base.field :lang_code, type: String
    base.index({lang_id: 1})
    base.index({lang_code: 1})

    base.before_create :update_lang_code
    base.before_save :update_lang_code, if: :lang_id_changed?
  end

  def update_lang_code
    self.lang_code = self.lang.code
  end

  def lang_code=(code)
    if code != self.lang_code
      lang = Lang.where(code: code).first
      if lang
        self.lang = lang
      else
        throw "invalid lang_code"
      end
    end
    super(code)
  end
end
