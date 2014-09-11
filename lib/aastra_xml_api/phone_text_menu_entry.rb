################################################################################
# Aastra XML API Classes - PhoneTextMenuEntry
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for PhoneTextMenu object.
################################################################################

module AastraXmlApi
  class PhoneTextMenuEntry < Phone
    @name
    @url
    @selection
    @icon
    @dial

    # Create new text menu entry with given name to be displayed, url to be
    # called when selected. Selection is the value appended to a custom URI
    # attached to a softkey.  This will be added as either ?selection=value
    # or &selection=value depending on if the URI already has parameters.
    # icon is the index of the icon to be displayed to the left of the
    # given entry.  dial is the number to call if the user pushes a softkey
    # with URI SoftKey:Dial2.
    def initialize(name, url, selection, icon, dial)
      @name = name
      @url = url
      @selection = selection
      @icon = icon
      @dial = dial
      @selection = nil if @selection == ''
      @icon = nil if @icon == ''
      @dial = nil if @dial == ''
    end

    # Returns the name associated with this entry.
    def getName
      return @name
    end

    # Create XML text output of this entry.
    def render
      xml = "<MenuItem"
      xml += " icon=\"#{@icon}\"" if not @icon.nil?
      xml += ">\n"
      xml += "<Prompt>#{escape(@name)}</Prompt>\n"
      xml += "<URI>#{escape(@url)}</URI>\n"
      xml += "<Selection>#{escape(@selection)}</Selection>\n" if not @selection.nil?
      xml += "<Dial>#{@dial}</Dial>\n" if not @dial.nil?
      xml += "</MenuItem>\n"
      return xml
    end
  end
end
