################################################################################
# Aastra XML API Classes - AastraIPPhoneExecuteEntry
# Firmware 1.4.1 or better
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for AastraIPPhoneExecute object.
################################################################################

class AastraIPPhoneExecuteEntry < AastraIPPhone
  @url
  @interruptCall

  # Create a new action to be performed.  if interruptCall is not nil then
  # a currently active call can be interrupted by this action.
  def initialize(url, interruptCall)
    @url = url
    @interruptCall = interruptCall
  end

  # Create XML text output for this entry.
  def render
    url = escape(@url)
    xml = "<ExecuteItem URI=\"#{url}\""
    xml += " interruptCall=\"no\"" if @interruptCall == "no"
    xml += "/>\n"
    return xml
  end
end
