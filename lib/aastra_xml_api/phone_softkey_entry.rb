################################################################################
# Aastra XML API Classes - PhoneSoftkeyEntry
# Firmware 2.2.0 or better
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for Phone object.
################################################################################

module AastraXmlApi
  class PhoneSoftkeyEntry
    @index
    @label
    @uri
    @icon

    # Create new softkey entry at index showing on screen with label. When
    # pressed will call URI. Next to the label text the given icon
    # will be shown.
    def initialize(index, label, uri, icon)
      @index = index
      @label = label
      @uri = uri
      @icon = icon
    end

    # Create XML text output for this entry.
    def render
      xml = "<SoftKey index=\"#{@index}\""
      xml += " icon=\"#{@icon}\"" if not @icon.nil?
      xml += ">\n"
      xml += "<Label>#{@label}</Label>\n"
      xml += "<URI>#{@uri}</URI>\n"
      xml += "</SoftKey>\n"
      return xml
    end
  end
end
