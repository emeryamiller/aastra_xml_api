################################################################################
# Aastra XML API Classes - PhoneExecute
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneExecute object.
#
# Public methods
#
# Inherited from Phone
#     setBeep to enable a notification beep with the object (optional)
#
# Specific to the object
#     setTriggerDestroyOnExit to set the triggerDestroyOnExit tag to "yes" (optional)
#     addEntry(url,interruptCall) to add an action to be executed.
#
# Example
#     require 'PhoneExecute.class.php'
#     execute = PhoneExecute.new
#     execute.addEntry('http://myserver.com/script.php?choice=2')
#     execute.addEntry('Command: Reset')
#     aastra_output execute
#
################################################################################

module AastraXmlApi
  class PhoneExecute < Phone
    @defaultIndex
    @triggerDestroyOnExit

    # Add a url (action to be performed).  If interruptCall is not nil, then
    # then if a dial action is given, the current call will be put on hold.
    # Default behavior is to not allow a current active call to be
    # interrupted.
    def addEntry(url, interruptCall=nil)
      @entries += [PhoneExecuteEntry.new(url, interruptCall)]
    end

    # When set, the previous user interface XML object is destroyed
    # if its destroyOnExit tag is also set to yes.
    def setTriggerDestroyOnExit
      @triggerDestroyOnExit = "yes"
    end

    # Create XML text output.
    def render
      title = escape(@title)
      out = "<AastraIPPhoneExecute"
      out += " Beep=\"yes\"" if @beep == "yes"
      out += " triggerDestroyOnExit=\"yes\"" if @triggerDestroyOnExit == "yes"
      out += ">\n"
      @entries.each do |entry|
        out += entry.render
      end
      out += "</AastraIPPhoneExecute>\n"
      return out
    end
  end
end
