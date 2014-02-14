require "aastra_xml_api/version"

(Dir['aastra_xml_api/*'] - ['aastra_xml_api/AastraIPPhoneGDImage.rb']).each do |path|
  require_relative path
end

module AastraXmlApi
end
