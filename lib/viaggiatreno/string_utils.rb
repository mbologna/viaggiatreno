# Class that contains all methods to deal with strings
class StringUtils
  # utility method
  def self.remove_newlines_tabs_and_spaces(str)
    str.content.delete("\r").delete("\n").tr("\t", ' ').gsub(/ +/, ' ').strip
  end
end
