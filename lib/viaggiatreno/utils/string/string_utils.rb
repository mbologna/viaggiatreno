# Class that contains all methods to deal with strings
class StringUtils
  DELAY_STR = 'ritardo'.freeze
  STOPS_DETAIL = '» Vedi dettaglio fermate'.freeze
  RESULT_BLOCK = 'bloccorisultato'.freeze
  RESULT_CENTRAL = 'corpocentrale'.freeze
  CLASS_ATTRIBUTE_NAME = 'class'.freeze
  EMPTY_STRING = ''.freeze
  WHITESPACE = ' '.freeze
  SUPPRESSED_STOP = 'Fermata soppressa'.freeze

  # utility method
  def self.remove_newlines_tabs_and_spaces(str)
    str.delete("\r").delete("\n").tr("\t", ' ').gsub(/ +/, ' ').strip
  end
end
