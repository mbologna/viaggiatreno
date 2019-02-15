# Class that contains all methods to deal with strings
class StringUtils
  DELAY_STR = 'ritardo'.freeze
  STOPS_DETAIL = '» Vedi dettaglio fermate'.freeze
  RESULT_BLOCK = 'bloccorisultato'
  RESULT_CENTRAL = 'corpocentrale'
  CLASS_ATTRIBUTE_NAME = 'class'
  EMPTY_STRING = ''
  WHITESPACE = ' '
  SUPPRESSED_STOP = 'Fermata soppressa'

  # utility method
  def self.remove_newlines_tabs_and_spaces(str)
    str.delete("\r").delete("\n").tr("\t", ' ').gsub(/ +/, ' ').strip
  end
end
