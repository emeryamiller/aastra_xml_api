################################################################################
# Aastra XML API Classes - PhoneFormattedTextScreenEntry
# Firmware 2.0 or better
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for PhoneFormattedTextScreen object.
################################################################################

module AastraXmlApi
  class PhoneFormattedTextScreenEntry < Phone
    @text
    @size
    @align
    @type

    # Creates new formatted text entry.  size is one of 'normal' (default)
    # or 'double'. align is one of 'left' (default), 'center', or 'right'.
    # type must be one of 'normal', 'scrollstart', or 'scrollend'.
    def initialize(text, size, align, type)
      if size == 'double' then
        @text = convert_high_ascii(text)
      else
        @text = text
      end
      @size = size
      @align = align
      @type = type
    end

    # Create XML text output for this entry.
    def render
      case @type
      when "normal"
        xml = "<Line"
        xml += " Size=\"#{@size}\"" if not @size.nil?
        xml += " Align=\"#{@align}\"" if not @align.nil?
        xml += ">"
        xml += "#{escape(@text)}</Line>\n"
      when "scrollstart"
        xml = "<Scroll"
        xml += " Height=\"#{@size}\"" if not @size.nil?
        xml += ">\n"
      when "scrollend" then xml = "</Scroll>\n"
      end
      return xml
    end
  end
end
