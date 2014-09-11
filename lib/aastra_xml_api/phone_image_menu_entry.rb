################################################################################
# Aastra XML API Classes - PhoneImageMenuEntry
# Firmware 2.0 or better
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for PhoneImageMenu object.
################################################################################

module AastraXmlApi
  class PhoneImageMenuEntry < Phone
    @key
    @uri

    # Create a new mapping for a user pressed key and a URI to call.
    def initialize(key, uri)
      @key = key
      @uri = uri
    end

    # Create XML text output for this entry.
    def render
      return "<URI key=\"#{@key}\">#{escape(@uri)}</URI>\n"
    end
  end
end
