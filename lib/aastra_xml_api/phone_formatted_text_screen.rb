################################################################################
# Aastra XML API Classes - FormattedPhoneTextScreen
# Copyright Aastra Telecom 2008
#
# PhoneFormattedTextScreen object.
#
# Public methods
#
# Inherited from Phone
#     setDestroyOnExit to set DestroyonExit parameter to 'yes', 'no' by default (optional)
#     setCancelAction(uri) to set the cancel parameter with the URI to be called on Cancel (optional)
#     setBeep to enable a notification beep with the object (optional)
#     setLockIn to set the Lock-in tag to 'yes' (optional)
#     setAllowAnswer to set the allowAnswer tag to 'yes' (optional)
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     addSoftkey(index, label, uri) to add custom softkeys to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#
# Specific to the object
#     addLine(text,size,align) to add a formatted line
#     setScrollStart(height) to define the beginning of the scrolling section and its height
#     setScrollEnd to define the end of the scrolling section
#     setAllowDTMF to allow DTMF passthrough on the object
#     setDoneAction(uri) to set the URI to be called when the user selects the default "Done" key (optional)
#
# Example
#     require 'PhoneFormattedTextScreen.rb'
#     ftext = PhoneFormattedTextScreen.new
#     ftext.setDestroyOnExit
#     ftext.addLine('Formatted Screen', 'double', 'center')
#     ftext.setScrollStart('2')
#     ftext.addLine('Scrolled text1')
#     ftext.addLine('Scrolled text2')
#     ftext.addLine('Scrolled text3')
#     ftext.addLine('Scrolled text4')
#     ftext.addLine('Scrolled text5')
#     ftext.setScrollEnd
#     ftext.addLine('Footer',NULL,'center')
#     ftext.addSoftkey('1', 'Label', 'http://myserver.com/script.php?action=1','1')
#     ftext.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#     ftext.addIcon('1', 'Icon:Envelope')
#     aastra_output ftext
#
################################################################################

module AastraXmlApi
  class PhoneFormattedTextScreen < Phone
    @doneAction
    @allowDTMF

    # Add a line of formatted text. size can only be 'normal' (default)
    # or 'double'. align can be one of 'left' (default), 'center',
    # or 'right'.
    def addLine(text, size=nil, align=nil)
      @entries += [PhoneFormattedTextScreenEntry.new(text, size, align, 'normal')]
    end

    # Starts the beginning of a scrolling section on the display. If height
    # is not given, then all available space is used to display the scrolling
    # section. Otherwise, height cannot be bigger than 2.
    def setScrollStart(height=nil)
      @entries += [PhoneFormattedTextScreenEntry.new(nil, height, nil, 'scrollstart')]
    end

    # Sets the end of a scrolling section on the display.
    def setScrollEnd
      @entries += [PhoneFormattedTextScreenEntry.new(nil, nil, nil, 'scrollend')]
    end

    # Defines URI to call when the user selects the 'Done' softkey.
    def setDoneAction(uri)
      @doneAction = uri
    end

    # Allows keypad strokes to generate DTMF when a call is in progress
    # while this object is displayed.
    def setAllowDTMF
      @allowDTMF = "yes"
    end

    # Create XML text output.
    def render
      out = "<AastraIPPhoneFormattedTextScreen"
      out += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      if not @cancelAction.nil? then
        cancelAction = escape(@cancelAction)
        out += " cancelAction=\"#{cancelAction}\""
      end
      if not @doneAction.nil? then
        doneAction = escape(@doneAction)
        out += " doneAction=\"#{doneAction}\""
      end
      out += " Beep=\"yes\"" if @beep == "yes"
      out += " LockIn=\"yes\"" if @lockin == "yes"
      out += " allowAnswer=\"yes\"" if @allowAnswer == "yes"
      out += " Timeout=\"#{@timeout}\"" if @timeout != 0
      out += " allowDTMF=\"#{yes}\"" if @allowDTMF == "yes"
      out += ">\n"
      @entries.each do |entry|
        out += entry.render
      end
      @softkeys.each do |softkey|
        out += softkey.render
      end
      iconList = 0
      @icons.each do |icon|
        if iconList == 0 then
          out += "<IconList>\n"
          iconList = 1
        end
        out += icon.render
      end
      out += "</IconList>\n" if iconList != 0
      out += "</AastraIPPhoneFormattedTextScreen>\n"
      return out
    end
  end
end
