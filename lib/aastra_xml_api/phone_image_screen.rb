################################################################################
# Aastra XML API Classes - PhoneImageScreen
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneImageScreen object.
#
# Public methods
#
# Inherited from Phone
#     setCancelAction(uri) to set the cancel parameter with the URI to be called on Cancel (optional)
#     setBeep to enable a notification beep with the object (optional)
#     setLockIn to set the Lock-in tag to 'yes' (optional)
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     addSoftkey(index,label,uri,icon_index) to add custom softkeys to the object (optional)
#     addIcon(index,icon) to add custom icons to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#
# Specific to the object
#     setImage(image) to define the image to be displayed
#     setGDImage(GDImage) to use a GDImage for display, the size is forced to 40x144
#     setAlignment(vertical,horizontal) to define image alignment
#     setSize(height,width) to define image size
#     setAllowDTMF to allow DTMF passthrough on the object
#
# Example
#
#     Using a Pixel image
#
#     require PhoneImageScreen.rb'
#     images = PhoneImageScreen.new
#     images.setDestroyOnExit
#     images.setSize(40, 40)
#     images.setImage('fffffffc02fffffffee4ffffbfffc05fffe7ff7a7ffffffffeffeebd7fffffea6bcfffffe796f3feff6fa289f0a86f4866fa20df42414595dd0134f8037ed1637f0e2522b2dd003b6eb936f05fffbd4f4107bba6eb0080e93715000010b754001281271408c640252081b1b22500013c5c66201368004e04467520dc11067152b82094d418e100247205805494780105002601530020931400020ac5c91088b0f2b08c21c07d0c2006009fdfe81f80efe0107fe0fb1c3ffff8ffc3fffef8f7febffbfcf87ffbff64')
#     images.addSoftkey('1', 'Mail', 'http://myserver.com/script.php?action=1', '1')
#     images.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#     images.addIcon('1', 'Icon:Envelope')
#     aastra_output images
#
#     Using a GD image
#
#    require 'PhoneGDImage.class.php'
#    require 'PhoneImageScreen.class.php'
#    phoneImageGD = PhoneGDImage.new
#    object = PhoneImageScreen.new
#    time = Time.now.strftime("%H:%M")
#    phoneImageGD.drawttftext(30, 0, 10, 39, time, 1, 'Ni7seg.ttf');
#    object.setGDImage(phoneImageGD)
#    aastra_output object
#
################################################################################

module AastraXmlApi
  class PhoneImageScreen < Phone
    @image
    @verticalAlign
    @horizontalAlign
    @height
    @width
    @allowDTMF

    # Set the image as a string of hex characters.
    def setImage(image)
      @image = image
    end

    # Set the alignment of the image.  vertical is one of 'top',
    # 'middle' (default), or 'bottom'.  horizontal is one of 'left',
    # 'middle' (default), or 'right'.
    def setAlignment(vertical=nil, horizontal=nil)
      @verticalAlign = vertical
      @horizontalAlign = horizontal
    end

    # Sets the size of the image.  Must match the actual image size.
    def setSize(height, width)
      @height = height
      @width = width
    end

    # Sets the image using an externally generated GD image.  This should be
    # done with an PhoneGDImage.
    def setGDImage(gdImage)
      img = gdImage.getGDImage
      byte = 0
      i = 0
      imageHexString = ""
      for x in 0..143
        for y in 0..39
          rgb = img.getPixel(x, y)
          byte += 2**(7-(i%8)) if rgb > 0
          if (i%8) == 7 then
            byteHex ="%02x" % byte
            imageHexString += byteHex
            byte = 0
          end
          i += 1
        end
      end
      setImage(imageHexString)
      setSize(40,144)
    end

    # When set, allows the user's pressed keys to be sent as DTMF through
    # the phone when the phone is in an active call.
    def setAllowDTMF
      @allowDTMF = "yes"
    end

    # Creates XML text output.
    def render
      out = "<AastraIPPhoneImageScreen"
      out += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      out += " cancelAction=\"#{escape(@cancelAction)}\"" if not @cancelAction.nil?
      out += " Beep=\"yes\"" if @beep == "yes"
      out += " LockIn=\"yes\"" if @locking == "yes"
      out += " Timeout=\"#{@timeout}\"" if @timeout != 0
      out += " allowDTMF=\"yes\"" if @allowDTMF == "yes"
      out += ">\n"
      out += "<Image"
      out += " verticalAlign=\"#{@verticalAlign}\"" if not @verticalAlign.nil?
      out += " horizontalAlign=\"#{@horizontalAlign}\"" if not @horizontalAlign.nil?
      out += " height=\"#{@height}\"" if not @height.nil?
      out += " width=\"#{@width}\"" if not @width.nil?
      out += ">#{@image}</Image>\n"
      @softkeys.each { |softkey| out += softkey.render }
      iconList = 0
      @icons.each do |icon|
        if iconList == 0 then
          out += "<IconList>\n"
          iconList = 1
        end
        out += icon.render
      end
      out += "</IconList>\n" if iconList != 0
      out += "</AastraIPPhoneImageScreen>\n"
      return out
    end
  end
end
