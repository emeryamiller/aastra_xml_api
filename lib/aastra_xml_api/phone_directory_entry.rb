########################################################################################################
# Aastra XML API Classes - PhoneDirectoryEntry
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Internal class for PhoneDirectory object.
########################################################################################################

module AastraXmlApi
  class PhoneDirectoryEntry < Phone
    @name
    @telephone

    # Create new name and number entry.  Overrides the initialize method
    # of Phone.
    def initialize(name, telephone)
      @name = name
      @telephone = telephone
    end

    # Get the name associated with this entry.
    def getName
      @name
    end

    # Create XML text output for this entry.
    def render
      name = escape(@name)
      telephone = escape(@telephone)
      return "<MenuItem>\n<Prompt>#{name}</Prompt>\n<URI>#{telephone}</URI>\n</MenuItem>\n"
    end
  end
end
