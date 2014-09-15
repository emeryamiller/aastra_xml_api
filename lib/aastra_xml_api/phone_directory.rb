################################################################################
# Aastra XML API Classes - PhoneDirectory
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneDirectory object.
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
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     addSoftkey(index,label,uri,icon_index) to add custom softkeys to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#
# Specific to the object
#     setNext(next) to set URI of the next page (optional)
#     setPrevious(previous) to set URI of the previous page (optional)
#     addEntry(name,phone) to add an element in the list to be displayed, at least one is needed.
#     natsortbyname to order the list
#
# Example
#     require 'PhoneDirectory.rb'
#     directory = PhoneDirectory.new
#     directory.setTitle('Title')
#     directory.setNext('http://myserver.com/script.php?page=2')
#     directory.setPrevious('http://myserver.com/script.php?page=0')
#     directory.setDestroyOnExit
#     directory.addEntry('John Doe', '200')
#     directory.addEntry('Jane Doe', '201')
#     directory.natsortByName
#     directory.addSoftkey('1', 'Label', 'http://myserver.com/script.php?action=1')
#     directory.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#     aastra_output directory
#
################################################################################

module AastraXmlApi
  class PhoneDirectory < Phone
    @next
    @previous

    # Set the URI to load the next page of the directory.
    def setNext(nextval)
      @next = nextval
    end

    # Set the URI to load the previous page of the directory.
    def setPrevious(previous)
      @previous = previous
    end

    # Add directory entry with a name to be displayed and a telephone
    # number to dial.
    def addEntry(name, telephone)
      @entries += [PhoneDirectoryEntry.new(name, telephone)]
    end

    # Sort array of names using natural sort order. i.e. Bob2 comes
    # before Bob10.
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
      out = "<AastraIPPhoneDirectory"
      if not @previous.nil? then
        previous = escape(@previous)
        out += " previous=\"#{previous}\""
      end
      if not @next.nil? then
        nextval = escape(@next)
        out += " next=\"#{nextval}\""
      end
      out += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      if not @cancelAction.nil? then
        cancelAction = escape(@cancelAction)
        out += " cancelAction=\"#{cancelAction}\""
      end
      out += " Beep=\"yes\"" if @beep == "yes"
      out += " LockIn=\"yes\"" if @lockin == "yes"
      out += " Timeout=\"#{@timeout}\"" if @timeout != 0
      out += ">\n"
      if not @title.nil? then
        title = escape(title)
        out += "<Title"
        out += " wrap=\"yes\"" if @title_wrap == "yes"
        out += ">#{title}</Title>\n"
      end
      index = 0
      @entries.each do |entry|
        out += entry.render if index < 30
        index += 1
      end
      @softkeys.each do |softkey|
        out += softkey.render
      end
      out += "</AastraIPPhoneDirectory>\n"
      return out
    end
  end
end
