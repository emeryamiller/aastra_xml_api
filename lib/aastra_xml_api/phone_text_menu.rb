################################################################################
# Aastra XML API Classes - PhoneTextMenu
# Copyright Aastra Telecom 2008
#
# PhoneTextMenu object.
#
# Public methods
#
# Inherited from Phone
#     setTitle(Title) to setup the title of an object (optional)
#     setTitleWrap to set the title to be wrapped on 2 lines (optional)
#     setDestroyOnExit to set DestroyOnExit parameter to "yes" (optional)
#     setCancelAction(uri) to set the cancel parameter with the URI to be called on Cancel (optional)
#     setBeep to enable a notification beep with the object (optional)
#     setLockIn to set the Lock-in tag to 'yes' (optional)
#     setAllowAnswer to set the allowAnswer tag to 'yes' (optional)
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     addSoftkey(index,label,uri,icon_index) to add custom softkeys to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#
# Specific to the object
#     setDefaultIndex(index) to set the default selection in the list (optional)
#     setStyle(style) to set the style of the list numbered/none/radio (optional)
#     setWrapList to allow 2 lines items (optional)
#     addEntry(name,url,selection,icon,dial) to add an element in the list to be displayed
#     natsortbyname to order the list
#
# Example 1
#    require 'PhoneTextMenu.rb'
#    menu = PhoneTextMenu.new
#    menu.setTitle('Title')
#    menu.setDestroyOnExit
#    menu.setDeFaultIndex('3')
#    menu.addEntry('Choice 2', 'http://myserver.com/script.php?choice=2', 'Value=2')
#    menu.addEntry('Choice 1', 'http://myserver.com/script.php?choice=1', 'Value=1')
#    menu.addEntry('Choice 3', 'http://myserver.com/script.php?choice=3', 'Value=3')
#    menu.natsortByName
#    menu.addSoftkey('1', 'My Select', 'http://myserver.com/script.php?action=1')
#    menu.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#    aastra_output menu
#
# Example 2
#    require 'PhoneTextMenu.rb'
#    menu = PhoneTextMenu.new
#    menu.setTitle('Title')
#    menu.setDestroyOnExit
#    menu.setDeFaultIndex('2')
#    menu.addEntry('Choice 2', 'http://myserver.com/script.php?choice=2', 'Value=2','1')
#    menu.addEntry('Choice 1', 'http://myserver.com/script.php?choice=1', 'Value=1','2')
#    menu.addEntry('Choice 3', 'http://myserver.com/script.php?choice=3', 'Value=3','3')
#    menu.natsortByName
#    menu.addSoftkey('1', 'My Select', 'http://myserver.com/script.php?action=1')
#    menu.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#    menu.addIcon('1', 'Icon:PhoneOnHook')
#    menu.addIcon('2', 'Icon:PhoneOffHook')
#    menu.addIcon('3', 'Icon:PhoneRinging')
#    aastra_output menu
#
################################################################################

module AastraXmlApi
  class PhoneTextMenu < Phone
    @defaultIndex
    @style
    @wraplist
    @maxitems

    # Sets the default index to highlight when first shown.
    def setDefaultIndex(defaultIndex)
      @defaultIndex = defaultIndex
    end

    # Set the style to one of numbered (default), none, or radio.
    def setStyle(style)
      @style = style
    end

    # Add a menu entry with name displayed and calls url when selected.  The
    # selection option is the value appended to a custom softkey URL when
    # this item is highlighted. icon is a reference to an included icon
    # that is shown with the menu entry.  dial is what is called when
    # the user hits a softkey with the URI "SoftKey:Dial2".
    def addEntry(name, url, selection=nil, icon=nil, dial=nil)
      @entries += [PhoneTextMenuEntry.new(name, url, selection, icon, dial)]
    end

    # Allows entries in the list to wrap.
    def setWrapList
      @wraplist = "yes"
    end

    # Use natural order sorting to sort the menu by name.
    def natsortByName
      tmparray = []
      linklist = {}
      for i in 0..@entries.size-1
        tmparray += [@entries[i].getName]
        linklist[@entries[i].getName] = i
      end
      tmparray.extend(ArrayExtension)
      tmparray.natsort!
      newentries = []
      tmparray.each do |name|
        newentries += [@entries[linklist[name]]]
      end
      @entries = newentries
    end

    # Create XML text output.
    def render
      @maxitems = 30 if @maxitems.nil?
      xml = "<AastraIPPhoneTextMenu"
      xml += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      xml += " cancelAction=\"#{escape(@cancelAction)}\"" if not @cancelAction.nil?
      xml += " defaultIndex=\"#{@defaultIndex}\"" if not @defaultIndex.nil?
      xml += " style=\"#{@style}\"" if not @style.nil?
      xml += " Beep=\"yes\"" if @beep == "yes"
      xml += " LockIn=\"yes\"" if @lockin == "yes"
      xml += " wrapList=\"yes\"" if @wraplist == "yes"
      xml += " allowAnswer=\"yes\"" if @allowAnswer == "yes"
      xml += " Timeout=\"#{@timeout}\"" if @timeout != 0
      xml += ">\n"
      if not @title.nil? then
        xml += "<Title"
        xml += " wrap=\"yes\"" if @title_wrap == "yes"
        xml += ">#{escape(@title)}</Title>\n"
      end
      index = 0
      @entries.each do |entry|
        xml += entry.render if index < @maxitems
        index += 1
      end
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
      xml += "</AastraIPPhoneTextMenu>\n"
      return xml
    end
  end
end
