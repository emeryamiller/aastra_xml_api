require 'cgi'

(Dir['lib/aastra_xml_api/*'] - ['lib/aastra_xml_api/AastraIpPhoneGDImage.rb']).each do |path|
  name = File.split(path)[1][0..-4]
  require "aastra_xml_api/#{name}"
end

module AastraXmlApi
end
