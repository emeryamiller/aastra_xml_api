###############################################################################
# Aastra XML API Classes - Phone
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Phone is the root class for all the Aastra XML objects.
#
# Public methods
#     setTitle(Title) to setup the title of an object (optional)
#     setTitleWrap to set the title to be wrapped on 2 lines (optional)
#     setCancelAction(uri) to set the cancel parameter with the URI to be called on Cancel (optional)
#     setDestroyOnExit to set DestroyonExit parameter to 'yes', 'no' by default (optional)
#     setBeep to enable a notification beep with the object (optional)
#     setLockIn to set the Lock-in tag to 'yes' (optional)
#     setAllowAnswer to set the allowAnswer tag to 'yes' (optional)
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     addSoftkey(index,label,uri,icon_index) to add custom soktkeys to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#
###############################################################################

module AastraXmlApi
  class Phone
    @entries
    @softkeys
    @icons
    @title
    @title_wrap
    @destroyOnExit
    @cancelAction
    @refreshTimeout
    @refreshURL
    @beep
    @lockin
    @timeout
    @allowAnswer

    HIGHASCII = {
      "!\xc0!" => 'A',    # A`
      "!\xe0!" => 'a',    # a`
      "!\xc1!" => 'A',    # A'
      "!\xe1!" => 'a',    # a'
      "!\xc2!" => 'A',    # A^
      "!\xe2!" => 'a',    # a^
      "!\xc4!" => 'Ae',   # A:
      "!\xe4!" => 'ae',   # a:
      "!\xc3!" => 'A',    # A~
      "!\xe3!" => 'a',    # a~
      "!\xc8!" => 'E',    # E`
      "!\xe8!" => 'e',    # e`
      "!\xc9!" => 'E',    # E'
      "!\xe9!" => 'e',    # e'
      "!\xca!" => 'E',    # E^
      "!\xea!" => 'e',    # e^
      "!\xcb!" => 'Ee',   # E:
      "!\xeb!" => 'ee',   # e:
      "!\xcc!" => 'I',    # I`
      "!\xec!" => 'i',    # i`
      "!\xcd!" => 'I',    # I'
      "!\xed!" => 'i',    # i'
      "!\xce!" => 'I',    # I^
      "!\xee!" => 'i',    # i^
      "!\xcf!" => 'Ie',   # I:
      "!\xef!" => 'ie',   # i:
      "!\xd2!" => 'O',    # O`
      "!\xf2!" => 'o',    # o`
      "!\xd3!" => 'O',    # O'
      "!\xf3!" => 'o',    # o'
      "!\xd4!" => 'O',    # O^
      "!\xf4!" => 'o',    # o^
      "!\xd6!" => 'Oe',   # O:
      "!\xf6!" => 'oe',   # o:
      "!\xd5!" => 'O',    # O~
      "!\xf5!" => 'o',    # o~
      "!\xd8!" => 'Oe',   # O/
      "!\xf8!" => 'oe',   # o/
      "!\xd9!" => 'U',    # U`
      "!\xf9!" => 'u',    # u`
      "!\xda!" => 'U',    # U'
      "!\xfa!" => 'u',    # u'
      "!\xdb!" => 'U',    # U^
      "!\xfb!" => 'u',    # u^
      "!\xdc!" => 'Ue',   # U:
      "!\xfc!" => 'ue',   # u:
      "!\xc7!" => 'C',    # ,C
      "!\xe7!" => 'c',    # ,c
      "!\xd1!" => 'N',    # N~
      "!\xf1!" => 'n',    # n~
      "!\xdf!" => 'ss'
    }

    # Create an Phone object and set initial values. Everything
    # sent to the phone will inherit from this class.
    def initialize
      @entries = []
      @softkeys = []
      @icons = []
      @refreshTimeout = 0
      @timeout = 0
    end

    # Set the title of the Phone object.  Typically displayed on the
    # top of the phone.
    def setTitle(title)
      @title = title
    end

    # Allow the title to wrap over multiple lines when displayed.
    def setTitleWrap
      @title_wrap = "yes"
    end

    # Set refresh timeout (seconds) and the URI to load when the
    # timeout is reached.
    def setRefresh(timeout, url)
      @refreshTimeout = timeout
      @refreshURL = url
    end

    # Beep phone when XML is received.
    def setBeep
      @beep = "yes"
    end

    # Do not keep the object in the phone browser after exit.
    def setDestroyOnExit
      @destroyOnExit = "yes"
    end

    # Defines the URI to call when the user cancels the XML object.
    def setCancelAction(cancelAction)
      @cancelAction = cancelAction
    end

    # Ignores all keys that would cause the screen to exit without using
    # keys defined by the object.
    def setLockIn
      @lockin = "yes"
    end

    # Override the default 45 second timeout.  A value of 0 will disable
    # timeout.
    def setTimeout(timeout)
      @timeout = timeout
    end

    # Applies only to the non-softkey phones (53i).  When set, the phone
    # displays 'Ignore' and 'Answer' if the XML object is displayed when
    # the phone is ringing.
    def setAllowAnswer
      @allowAnswer = "yes"
    end

    # Returns the set refresh timeout value.
    def getRefreshTimeout
      return @refreshTimeout
    end

    # Returns the set refresh URI.
    def getRefreshURL
      return @refreshURL
    end

    # Add a softkey to be displayed while the XML object is on the screen.
    # Only available on the 9480i, 9480iCT, 55i, 57i, and 57iCT.  Softkey
    # will be at position index.  label is what is displayed next to the
    # softkey button.  uri is what is called when the softkey is pressed.
    # Optionally, icon is the index of the icon to display to the left of
    # the label.
    def addSoftkey(index, label, uri, icon=nil)
      @softkeys += [PhoneSoftkeyEntry.new(index, escape(label), escape(uri), icon)]
    end

    # Add an icon to be used by either a softkey of PhoneTextMenu.
    # Only available on the 55i, 57i, and 57iCT. The index is the same as
    # what is referenced by addSoftkey or PhoneTextMenu.addEntry.
    # The icon can be either a predefined icon or the hex of an icon image.
    def addIcon(index, icon)
      @icons += [PhoneIconEntry.new(index, icon)]
    end

    # Convert any HTML characters to the proper escaped format.
    # i.e. > becomes &gt;
    def escape(s)
      return nil if s.nil?
      CGI.escapeHTML(s)
    end

    # Convert characters when using double sized text in
    # PhoneFormattedTextScreen.
    def convert_high_ascii(s)
      ret = ""
      s.each do |char|
        if not HIGHASCII[char].nil? then
          ret += HIGHASCII[char]
        else
          ret += char
        end
      end
      return ret
    end
  end
end
