################################################################################
# Aastra XML API Classes - AastraIpPhoneConfiguration
# Copyright Aastra Telecom 8007
#
# Ruby adaptation by Carlton O'Riley
#
# AastraIpPhoneConfiguration object.
#
# Public methods
#
# Inherited from AastraIpPhone
#     setBeep to enable a notification beep with the object (optional)
#
# Specific to the object
#     addEntry(parameter,value) to add a configuration change.
#     setTriggerDestroyOnExit to set the triggerDestroyOnExit tag to
#     "yes" (optional)
#
# Example
#     require 'AastraIpPhoneConfiguration.rb'
#     configuration = AastraIpPhoneConfiguration.new
#     configuration.addEntry('softkey1 label','Test')
#     configuration.addEntry('softkey1 type','xml')
#     configuration.setTriggerDestroyOnExit
#     configuration.setBeep
#     aastra_output configuration
#
################################################################################

module AastraXmlApi
  class AastraIpPhoneConfiguration < AastraIpPhone
    # Adds a parameter and value entry to the list.
    def addEntry(parameter, value)
      @entries += [AastraIpPhoneConfigurationEntry.new(parameter, value)]
    end

    # When set, the previous user interface XML object is destroyed
    # if its destroyOnExit tag is also set to yes.
    def setTriggerDestroyOnExit
      @triggerDestroyOnExit = "yes"
    end

    # Create XML text output.
    def render
      out = "<AastraIpPhoneConfiguration"
      out += " Beep=\"yes\"" if @beep == "yes"
      out += " triggerDestroyOnExit=\"yes\"" if @triggerDestroyOnExit == "yes"
      out += ">\n"
      @entries.each do |entry|
        out += entry.render
      end
      out += "</AastraIpPhoneConfiguration>\n"
      return out
    end
  end
end
