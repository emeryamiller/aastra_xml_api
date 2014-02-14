require 'AastraIPPhone.rb'
require 'AastraIPPhoneConfigurationEntry.rb'

################################################################################
# Aastra XML API Classes - AastraIPPhoneConfiguration
# Copyright Aastra Telecom 8007
#
# Ruby adaptation by Carlton O'Riley
#
# AastraIPPhoneConfiguration object.
#
# Public methods
#
# Inherited from AastraIPPhone
#     setBeep to enable a notification beep with the object (optional)
#
# Specific to the object
#     addEntry(parameter,value) to add a configuration change.
#     setTriggerDestroyOnExit to set the triggerDestroyOnExit tag to
#     "yes" (optional)
#
# Example
#     require 'AastraIPPhoneConfiguration.rb'
#     configuration = AastraIPPhoneConfiguration.new
#     configuration.addEntry('softkey1 label','Test')
#     configuration.addEntry('softkey1 type','xml')
#     configuration.setTriggerDestroyOnExit
#     configuration.setBeep
#     aastra_output configuration
#
################################################################################

class AastraIPPhoneConfiguration < AastraIPPhone

  # Adds a parameter and value entry to the list.
  def addEntry(parameter, value)
    @entries += [AastraIPPhoneConfigurationEntry.new(parameter, value)]
  end

  # When set, the previous user interface XML object is destroyed
  # if its destroyOnExit tag is also set to yes.
  def setTriggerDestroyOnExit
    @triggerDestroyOnExit = "yes"
  end

  # Create XML text output.
  def render
    out = "<AastraIPPhoneConfiguration"
    out += " Beep=\"yes\"" if @beep == "yes"
    out += " triggerDestroyOnExit=\"yes\"" if @triggerDestroyOnExit == "yes"
    out += ">\n"
    @entries.each do |entry|
      out += entry.render
    end
    out += "</AastraIPPhoneConfiguration>\n"
    return out
  end
  end
