class String
  ACCENTS = "äáàâãçëéèêïíìîñöóòõôőüúùûűÄÁÀÂÃÇËÉÈÊÏÍÌÎÑÖÓÒÕÔŐÜÚÙÛŰ".scan(/./u)
  ACCENTS_TR = [
    "aäáàâãcçeëéèêiïíìînñoöóòõôőuüúùûűAÄÁÀÂÃCÇEËÉÈÊIÏÍÌÎNÑOÖÓÒÕÔŐUÜÚÙÛŰ".scan(/./u),
    "aaaaaacceeeeeiiiiinnooooooouuuuuuAAAAAACCEEEEEIIIIINNOOOOOOOUUUUUU".scan(/./u),
  ]

  def slugify
    self.dup.tap do |str|
      ACCENTS_TR.first.each_with_index do |char, i|
        str.gsub!(char, ACCENTS_TR.last[i])
      end
      str.gsub!(/[^a-zA-Z0-9_ -]/, "")
      str.gsub!(/[ _-]+/, " ")
      str.strip!
      str.tr!(' ', "-")
    end
  end
end
