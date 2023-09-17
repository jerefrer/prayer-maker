# Prayer Maker

Practice
  has_and_belongs_to_many :prayers, dependent: :nullify

Prayer
  tibetan_title :string
  has_many :title_translations, as: Translation, dependent: :destroy
  has_many :subtitle_translations, as: Translation, dependent: :destroy
  has_many :author_translations, as: Translation, dependent: :destroy
  has_many :groups, dependent: :destroy

Group
  has_many :translations, dependent: :destroy
  practice_header:boolean
  add_to_toc:boolean

Translation
  language:string
  text:text