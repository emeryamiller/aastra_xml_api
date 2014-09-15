################################################################################
# Aastra XML API Classes - PhoneInputScreen
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneInputScreen object.
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
#     addSoftkey(index,label,uri,icon_index) to add custom softkeys to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#
# Specific to the object - Single Input
#     setURL(url) to set the URL to called after the input
#     setType(type) to set type of input ('IP', 'string', 'number', 'dateUS'...), 'string' by default
#     setDefault(default) to set default value for the input (optional)
#     setParameter(param) to set the parameter name to be parsed after the input
#     setInputLanguage(language) to set the language of the input (optional)
#     setPassword to set the Password parameter to 'yes', 'no' by default (optional)
#     setNotEditable to set the editable parameter to 'no', 'yes' by default (optional)
#     setEditable is now replaced by setNotEditable but kept for compatibility reasons (optional)
#     setPrompt(prompt) to set the prompt to be displayed for the input.
#
# Specific to the object - Multiple Inputs
#     setURL(url) to set the URL to called after the input
#     setType(type) to set the default type of input ('IP', 'string', 'number', 'dateUS'...), 'string' by default
#     setDefault(default) to set default default value for the input (optional)
#     setParameter(param) to set the default parameter name to be parsed after the input
#     setPassword to set the default Password parameter to 'yes', 'no' by default (optional)
#     setNotEditable to set the default editable parameter to 'no', 'yes' by default (optional)
#     setEditable is now replaced by setNotEditable but kept for compatibility reasons (optional)
#     setPrompt(prompt) to set the default prompt to be displayed for the input.
#     setDefaultIndex(index) to define the field index the object will use to start (optional) default is 1
#     setDisplayMode(display) to define the aspect of the display, normal/condensed (optional) default is normal.
#     setInputLanguage(language) to set the language of the input (optional)
#     addField(type) to add an input field and setting its type (IP, string, number, dateUS, timeUS,dateInt, timeInt or empty) if the type is an empty string then the type is inherited from the main object.
#     setFieldPassword(password) to set the password mode for the input field ('yes', no'), overrides the value set by setPassword for the field
#     setFieldEditable(editable) to set the input field editable mode ('yes', no'), overrides the value set by setEditable or setNotEditable for the field
#     setFieldParameter(parameter) to set the parameter name to be parsed after the global input, overrides the value set by setParameter for the field
#     setFieldPrompt(prompt)to set the prompt to be displayed for the input field, overrides the value set by setPrompt for the field
#     setFieldSelection(selection) to set the Selection tag for the field
#     setFieldDefault(default) to set default value for the input field, overrides the value set by setDefault for the field
#     addFieldSoftkey(index,label,uri,icon) to add custom softkeys to the input field, overrides the softkeys set by addSoftkey.
#
# Example 1 - Single Input
#     require 'PhoneInputScreen.rb'
#     input = PhoneInputScreen.new
#     input.setTitle('Title')
#     input.setPrompt('Enter your password')
#     input.setParameter('param')
#     input.setType('string')
#     input.setURL('http://myserver.com/script.php')
#     input.setPassword
#     input.setDestroyOnExit
#     input.setDefault('Default')
#     aastra_output input
#
# Example 2 - Multiple Inputs
#     require 'PhoneInputScreen.rb'
#     input = PhoneInputScreen.new
#     input.setTitle('Example 2')
#     input.setDisplayMode('condensed')
#     input.setURL('http://myserver.com/script.php')
#     input.setDestroyOnExit
#     input.addSoftkey('5', 'Done', 'SoftKey:Submit')
#     input.addField('string')
#     input.setFieldPrompt('Username:')
#     input.setFieldParameter('user')
#     input.addFieldSoftkey('3', 'ABC', 'SoftKey:ChangeMode')
#     input.addField('number')
#     input.setFieldPassword('yes')
#     input.setFieldPrompt('Pass:')
#     input.setFieldParameter('passwd')
#     aastra_output input
#
################################################################################

module AastraXmlApi
  class PhoneInputScreen < Phone
    @url
    @type
    @parameter
    @prompt
    @editable
    @default
    @password
    @defaultindex
    @displaymode
    @inputlanguage

    # Set URL to be called (html post) when the input is submitted.
    def setURL(url)
      @url = url
    end

    # Sets the type of all fields (see addField for values) unless overriden
    # by setFieldType.
    def setType(type)
      @type = type
    end

    # Sets all fields are editable. Kept only for compatibility.
    def setEditable
      @editable = "yes"
    end

    # Sets all fields as read only if not overriden by setFieldEditable.
    def setNotEditable
      @editable = "no"
    end

    # Set default value for all fields if not overriden by setFieldDefault.
    def setDefault(default)
      @default = default
    end

    # Set parameter name for all fields if not overriden by setFieldParameter.
    def setParameter(parameter)
      @parameter = parameter
    end

    # Set password input for all fields, masked by "*" characters if not
    # overriden by setFieldPassword.
    def setPassword
      @password = "yes"
    end

    # Prompt for all input fields, if not overriden by setFieldPrompt.
    def setPrompt(prompt)
      @prompt = prompt
    end

    # Defines which field 1 (default) through 6 the user will start input on.
    def setDefaultIndex(index)
      @defaultindex = index
    end

    # Can be one of normal (default) or condensed.
    def setDisplayMode(display)
      @displaymode = display
    end

    # Defines the language character set used for input.
    def setInputLanguage(input)
      @inputlanguage = input
    end

    # Add a new field to get input for.  The type can be one of IP,
    # string (default), number, timeUS, timeInt, dateUS, or dateInt.
    def addField(type=nil)
      @entries += [PhoneInputScreenEntry.new(type)]
    end

    # Sets the type (see addField for values) of the most recently added
    # field.
    def setFieldType(type)
      @entries[@entries.size-1].setType(type)
    end

    # Set the most recently added field as a password field and mask input
    # by "*" characters.
    def setFieldPassword
      @entries[@entries.size-1].setPassword
    end

    # Set the most recently added field as editable.  This is the default.
    def setFieldEditable
      @entries[@entries.size-1].setEditable
    end

    # Set the most recently added field's parameter name in the form post
    # when submitted.
    def setFieldParameter(parameter)
      @entries[@entries.size-1].setParameter(parameter)
    end

    # Set the most recently added field's prompt text.
    def setFieldPrompt(prompt)
      @entries[@entries.size-1].setPrompt(prompt)
    end

    # Set the most recently added field's default value.This is what is
    # displayed when first shown.
    def setFieldDefault(default)
      @entries[@entries.size-1].setDefault(default)
    end

    # Sets the most recently added field's selection tag which is added
    # to the request when the submit button is pressed while editing this
    # field.
    def setFieldSelection(selection)
      @entries[@entries.size-1].setSelection(selection)
    end

    # Adds a softkey to be displayed when the most recently added field
    # is highlighted.
    def addFieldSoftkey(index, label, uri, icon=nil)
      @entries[@entries.size-1].addSoftkey(index, label, uri, icon)
    end

    # Create XML text output.
    def render
      @type = 'string' if @type.nil?
      xml = "<AastraIPPhoneInputScreen type=\"#{@type}\""
      xml += " password=\"yes\"" if @password == "yes"
      xml += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      xml += " cancelAction=\"#{escape(@cancelAction)}\"" if not @cancelAction.nil?
      xml += " editable=\"no\"" if @editable == "no"
      xml += " Beep=\"yes\"" if @beep == "yes"
      xml += " defaultIndex=\"#{@defaultindex}\"" if not @defaultindex.nil?
      xml += " inputLanguage=\"#{@inputlanguage}\"" if not @inputlanguage.nil?
      xml += " displayMode=\"#{@displaymode}\"" if not @displaymode.nil?
      xml += " LockIn=\"yes\"" if @lockin == "yes"
      xml += " allowAnswer=\"yes\"" if @allowAnswer == "yes"
      xml += " Timeout=\"#{@timeout}\"" if @timeout != 0
      xml += ">\n"
      if not @title.nil? then
        xml += "<Title"
        out += " wrap=\"yes\"" if @title_wrap == "yes"
        xml += ">#{escape(@title)}</Title>\n"
      end
      xml += "<Prompt>#{escape(@prompt)}</Prompt>\n" if not @prompt.nil?
      xml += "<URL>#{escape(@url)}</URL>\n"
      xml += "<Parameter>#{@parameter}</Parameter>\n" if not @parameter.nil?
      xml += "<Default>#{@default}</Default>\n"
      @entries.each { |entry| xml += entry.render }
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
      xml += "</AastraIPPhoneInputScreen>\n"
      return xml
    end
  end
end
