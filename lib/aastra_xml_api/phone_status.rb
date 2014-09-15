################################################################################
# Aastra XML API Classes - PhoneStatus
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneStatus object.
#
# Public methods
#
# Inherited from Phone
#     setBeep to enable a notification beep with the object (optional)
#
# Specific to the object
#     setSession(session) to setup the session ID
#     setTriggerDestroyOnExit to set the triggerDestroyOnExit tag to
#     "yes" (optional)
#     addEntry(index,message,type,timeout) to add a message to be displayed
#     on the idle screen.
#
# Example
#     require 'PhoneStatus.rb'
#     status = PhoneStatus.new
#     status.setSession('Session');
#     status.setBeep
#     status.addEntry('1', 'Message 1', '', 0)
#     status.addEntry('2', 'Message 2', 'alert', 5)
#     aastra_output status
#
################################################################################

module AastraXmlApi
  class PhoneStatus < Phone
    @session
    @triggerDestroyOnExit

    # Sets the session associated with this status message.  Only important
    # if more than one application is sending status messages.
    def setSession(session)
      @session = session
    end

    # When set, the previous user interface XML object is destroyed
    # if its destroyOnExit tag is also set to yes.
    def setTriggerDestroyOnExit
      @triggerDestroyOnExit = "yes"
    end

    # Adds a new status message to be displayed at index. The type can only
    # be nothing (default) or alert which shows the message for 3 seconds.
    # The timeout can override the default 3 seconds for an alert message.
    def addEntry(index, message, type=nil, timeout=nil)
      @entries += [PhoneStatusEntry.new(index, message, type, timeout)]
    end

    # Create XML text output.
    def render
      xml = "<AastraIPPhoneStatus"
      xml += " Beep=\"yes\"" if @beep == "yes"
      xml += " triggerDestroyOnExit=\"yes\"" if @triggerDestroyOnExit == "yes"
      xml += ">\n"
      xml += "<Session>#{@session}</Session>\n"
      @entries.each { |entry| xml += entry.render }
      xml += "</AastraIPPhoneStatus>\n"
      return xml
    end
  end
end
