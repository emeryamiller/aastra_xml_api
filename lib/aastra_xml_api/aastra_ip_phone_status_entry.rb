################################################################################
# Aastra XML API Classes - AastraIpPhoneStatusEntry
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for AastraIpPhoneStatus object.
################################################################################

module AastraXmlApi
  class AastraIpPhoneStatusEntry < AastraIpPhone
    @index
    @message
    @type
    @timeout

    # Create new status message at index.  Type can only be "alert" or left
    # blank.  If the type is anything but blank, it is automatically set
    # to "alert".  The timeout overrides the default 3 seconds for an
    # alert message.
    def initialize(index, message, type=nil, timeout=nil)
      @index = index
      @message = message
      setType(type)
      @timeout = timeout
    end

    # Set the index of this message.
    def setIndex(index)
      @index = index
    end

    # Set the text of the message.
    def setMessage(message)
      @message = message
    end

    # Set the type of the message. Either "alert" or normal (blank and default)
    def setType(type)
      @type = type if type.nil?
      @type = "alert" if not type.nil?
    end

    # Set the timeout (in seconds) of an alert message
    def setTimeout(timeout)
      @timeout = timeout
    end

    # Create XML text output of this entry
    def render
      xml = "<Message index=\"#{escape(@index)}\""
      xml += " type=\"#{escape(@type)}\"" if not @type.nil?
      xml += " Timeout=\"#{@timeout}\"" if not @timeout.nil?
      xml += ">#{escape(@message)}</Message>\n"
      return xml
    end
  end
end
