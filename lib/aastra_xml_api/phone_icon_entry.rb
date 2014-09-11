################################################################################
# Aastra XML API Classes - IconEntry
# Firmware 2.0 or better
# Copyright Aastra Telecom 8007
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for Phone object.
################################################################################

module AastraXmlApi
  class PhoneIconEntry
    @index
    @icon

    # Create new icon entry available to be referenced as index.  The icon
    # can either be a predefined icon (i.e. Icon:PhoneOnHook) or the actual
    # hex data (as a string) of the icon.
    def initialize(index, icon)
      @index = index
      @icon = icon
    end

    # Create XML text output for this entry.
    def render
      return "<Icon index=\"#{@index}\">#{@icon}</Icon>\n"
    end
  end
end
