require 'cgi'

%w(version array_extensions phone phone_configuration phone_configuration_entry phone_directory phone_directory_entry
   phone_execute phone_execute_entry phone_formatted_text_screen phone_formatted_text_screen_entry phone_icon_entry
   phone_image_menu phone_image_menu_entry phone_image_screen phone_input_screen phone_input_screen_entry
   phone_softkey_entry phone_status phone_status_entry phone_text_menu phone_text_menu_entry phone_text_screen).each do |name|
  require "aastra_xml_api/#{name}"
end

module AastraXmlApi
end
