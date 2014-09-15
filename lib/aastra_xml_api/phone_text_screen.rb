################################################################################
# Aastra XML API Classes - PhoneTextScreen
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneTextScreen object.
#
# Public methods
#
# Inherited from Phone
#     setTitle(Title) to setup the title of an object (optional)
#     setTitleWrap to set the title to be wrapped on 2 lines (optional)
#     setDestroyOnExit to set DestroyonExit parameter to 'yes', 'no' by default (optional)
#     setCancelAction(uri) to set the cancel parameter with the URI to be called on Cancel (optional)
#     setBeep to enable a notification beep with the object (optional)
#     setLockIn to set the Lock-in tag to 'yes' (optional)
#     setAllowAnswer to set the allowAnswer tag to 'yes' (optional)
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     addSoftkey(index,label,uri,iconindex) to add custom softkeys to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#
# Specific to the object
#     setText(text) to set the text to be displayed.
#     setDoneAction(uri) to set the URI to be called when the user selects the default "Done" key (optional)
#     setAllowDTMF to allow DTMF passthrough on the object
#
# Example
#     require 'PhoneTextScreen.rb'
#     text = PhoneTextScreen.new
#     text.setTitle('Title')
#     text.setText('Text to be displayed.')
#     text.setDestroyOnExit
#     text.addSoftkey('1', 'Mail', 'http://myserver.com/script.php?action=1', '1')
#     text.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#     text.addIcon('1', 'Icon:Envelope')
#     aastra_output text
#
################################################################################

module AastraXmlApi
  class PhoneTextScreen < Phone
    @text
    @doneAction
    @allowDTMF

    # Set the text to be displayed on this screen.
    def setText(text)
      @text = text
    end

    # Set the URI to be called when done viewing this screen.
    def setDoneAction(uri)
      @doneAction = uri
    end

    # When set allows DTMF tones to be sent while viewing this screen.
    def setAllowDTMF
      @allowDTMF = "yes"
    end

    # Create XML text output.
    def render
      xml = "<AastraIPPhoneTextScreen"
      xml += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      xml += " cancelAction=\"#{escape(@cancelAction)}\"" if not @cancelAction.nil?
      xml += " doneAction=\"#{escape(@doneAction)}\"" if not @doneAction.nil?
      xml += " Beep=\"yes\"" if @beep == "yes"
      xml += " Timeout=\"#{@timeout}\"" if @timeout != 0
      xml += " LockIn=\"yes\"" if @lockin == "yes"
      xml += " allowAnswer=\"yes\"" if @allowAnswer == "yes"
      xml += " allowDTMF=\"yes\"" if @allowDTMF == "yes"
      xml += ">\n"
      if not @title.nil? then
        xml += "<Title"
        xml += " wrap=\"yes\"" if @title_wrap == "yes"
        xml += ">#{escape(@title)}</Title>\n"
      end
      xml += "<Text>#{escape(@text)}</Text>\n"
      @softkeys.each { |softkey| xml += softkey.render }
      iconList = 0
      @icons.each do |icon|
        if iconList == 0 then
          xml += "<IconList>\n"
          iconList = 1
        end
        xml += icon.render
      end
      xml += "</IconList>\n" if iconList != 0
      xml += "</AastraIPPhoneTextScreen>\n"
      return xml
    end
  end
end
