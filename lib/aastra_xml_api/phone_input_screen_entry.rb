################################################################################
# Aastra XML API Classes - PhoneInputScreenEntry
# Firmware 2.2.0 or better
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for PhoneInputScreen object.
################################################################################

module AastraXmlApi
  class PhoneInputScreenEntry
    @type
    @password
    @editable
    @parameter
    @prompt
    @default
    @selection
    @softkeys

    # Create new input field as a given type. The type can be one of IP,
    # string (default), number, timeUS, timeInt, dateUS, or dateInt.
    def initialize(type)
      @type = type
      @softkeys = []
    end

    # Set the type (see initialize for values) of this input field.
    def setType(type)
      @type = type
    end

    # Set this input field as a password field masked by "*" characters.
    def setPassword
      @password = "yes"
    end

    # Make this input field editable, i.e. not read only.
    def setEditable
      @editable = "yes"
    end

    # Set paramter name value to be used to identify this field on submit.
    def setParameter(parameter)
      @parameter = parameter
    end

    # Set prompt to be displayed to let user know what this field is for.
    def setPrompt(prompt)
      @prompt = prompt
    end

    # Set default value to load this field with.
    def setDefault(default)
      @default = default
    end

    # The contents of this will be added when the submit key is pressed while
    # editing this field.
    def setSelection(selection)
      @selection = selection
    end

    # Adds softkey to be displayed when editing this field.
    def addSoftkey(index, label, uri, icon=nil)
      @softkeys += [PhoneSoftkeyEntry.new(index, label, uri, icon)]
    end

    # Create XML text output for this entry.
    def render
      xml = "<InputField"
      xml += " type=\"#{@type}\"" if not @type.nil?
      xml += " password=\"yes\"" if @password == "yes"
      xml += " editable=\"yes\"" if @editable == "yes"
      xml += ">\n"
      xml += "<Prompt>#{@prompt}</Prompt>\n" if not @prompt.nil?
      xml += "<Parameter>#{@parameter}</Parameter>\n" if not @parameter.nil?
      xml += "<Selection>#{@selection}</Selection>\n" if not @selection.nil?
      xml += "<Default>#{@default}</Default>\n" if not @default.nil?
      @softkeys.each { |softkey| xml += softkey.render }
      xml += "</InputField>\n"
      return xml
    end
  end
end
