################################################################################
# Aastra XML API Classes - AastraIpPhoneConfigurationEntry
# Firmware 2.0 or better
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for AastraIpPhoneConfiguration object.
################################################################################
module AastraXmlApi
  class AastraIpPhoneConfigurationEntry < AastraIpPhone
    @parameter
    @value

    # Create a new parameter/value pair.  This overrides the
    # initialize method in AastraIpPhone.
    def initialize(parameter, value)
      @parameter = parameter
      @value = value
    end

    # Set the parameter for this entry.
    def setParameter(parameter)
      @parameter = parameter
    end

    # Set the value for this entry.
    def setValue(value)
      @value = value
    end

    # Create XML text output for this entry.
    def render
      parameter = escape(@parameter)
      value = escape(@value)
      xml = "<ConfigurationItem>\n"
      xml += "<Parameter>#{parameter}</Parameter>\n"
      xml += "<Value>#{value}</Value>\n"
      xml += "</ConfigurationItem>\n"
      return xml
    end
  end
end
