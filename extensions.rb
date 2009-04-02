class String
  ACCENTS = "äáàâãçëéèêïíìîñöóòõôőüúùûűÄÁÀÂÃÇËÉÈÊÏÍÌÎÑÖÓÒÕÔŐÜÚÙÛŰ".scan(/./u)
  ACCENTS_TR = [
    "aäáàâãcçeëéèêiïíìînñoöóòõôőuüúùûűAÄÁÀÂÃCÇEËÉÈÊIÏÍÌÎNÑOÖÓÒÕÔŐUÜÚÙÛŰ".scan(/./u),
    "aaaaaacceeeeeiiiiinnooooooouuuuuuAAAAAACCEEEEEIIIIINNOOOOOOOUUUUUU".scan(/./u),
  ]

  def slugify
    slug = self.dup
    ACCENTS_TR.first.each_with_index do |char, i|
      slug.gsub!(char, ACCENTS_TR.last[i])
    end
    slug.gsub!(/[^a-zA-Z0-9_ -]/, "")
    slug.gsub!(/[ _-]+/, " ")
    slug.strip!
    slug.tr!(' ', "-")
    slug
  end
end
