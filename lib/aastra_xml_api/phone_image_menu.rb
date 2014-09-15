################################################################################
# Aastra XML API Classes - PhoneImageMenu
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# PhoneImageMenu object.
#
# Public methods
#
# Inherited from Phone
#     setCancelAction(uri) to set the cancel parameter with the URI to be called on Cancel (optional)
#     setBeep to enable a notification beep with the object (optional)
#     setTimeout(timeout) to define a specific timeout for the XML object (optional)
#     setLockIn to set the Lock-in tag to 'yes' (optional)
#     addSoftkey(index,label,uri,icon_index) to add custom softkeys to the object (optional)
#     setRefresh(timeout,URL) to add Refresh parameters to the object (optional)
#
# Specific to the object
#     setImage(image)to define the image to be displayed
#     setGDImage(GDImage) to use a GDImage for display, the size is forced to 40x144
#     setAlignment(vertical,horizontal) to define image alignment
#     setSize(height,width) to define image size
#     setURIBase(uriBase) to define the base URI for the selections
#     addURI(key,uri) to add a selection key with its URI
#
# Example
#     require 'PhoneImageMenu.rb'
#     imagem = PhoneImageMenu.new
#     imagem.setDestroyOnExit
#     imagem.setSize(40,144)
#     imagem.setImage('fffffffc02fffffffee4ffffbfffc05fffe7ff7a7ffffffffeffeebd7fffffea6bcfffffe796f3feff6fa289f0a86f4866fa20df42414595dd0134f8037ed1637f0e2522b2dd003b6eb936f05fffbd4f4107bba6eb0080e93715000010b754001281271408c640252081b1b22500013c5c66201368004e04467520dc11067152b82094d418e100247205805494780105002601530020131400020a05c91088b002b08c21c0000c200000001fe800000000000000001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020041000004008300000ff08500000000c900000000710000000000000001401400000140140000014014000001401400000140140000000000000007c0ff00000c30880000081088000008108800000c30700000062000000000003f000001e02000000330200000021000000003301e000001e0330000000021000003f033000002001e0000020000000000001e000c03fc33003c013021007c02101201f00330ff03f001e000039000003e039001e00103f003300101f8021003007c03303f003c01e000000c00001e001c03f033007802002100f002002103e000001203c401702003cc0290ff039c02902101fc02b000007c03f01a003c020039018c0ff02d03c402102703c400001203ec01e000026402b0000264029000026c029000027c01a0000338000000033800000003100000000300000000030003f00003fc03000003fc02000003fc020000030001f0000300000000030001e000030002b000030002900003fc02900003fc01a00003f00000000310030000031c01e000031f003000033f81e00003f383000001e081e000008c003000003c01e00000fc03000001f000000003d001a0000390039000039002d00003f002700000f8012000007c000000001c0000000004000000000000000000000000000')
#     imagem.addURI('1','http://myserver.com?choice=1')
#     imagem.addURI('2','http://myserver.com?Choice=2')
#     imagem.addSoftkey('1', 'Label', 'http://myserver.com/script.php?action=1', '1')
#     imagem.addSoftkey('6', 'Exit', 'SoftKey:Exit')
#     imagem.addIcon('1', 'Icon:Envelope')
#     imagem.addIcon('2', 'FFFF0000FFFF0000')
#     aastra_output imagem
#
################################################################################

module AastraXmlApi
  class PhoneImageMenu < Phone
    @image
    @verticalAlign
    @horizontalAlign
    @height
    @width
    @uriBase

    # Sets the image to be displayed.  image must be a string of hex.
    def setImage(image)
      @image = image
    end

    # Sets the alignment of the image.  veritcal is one of 'top',
    # 'middle' (default), or 'bottom'.  horizontal is one of 'left',
    # 'middle' (default), or 'right'.
    def setAlignment(vertical=nil, horizontal=nil)
      @verticalAlign = vertical
      @horizontalAlign = horizontal
    end

    # Sets the size of the image to be displayed which must match the
    # actual images height and width.
    def setSize(height, width)
      @height = height
      @width = width
    end

    # Sets the base URI that is prepended to the URI for a specific key.
    def setURIBase(uriBase)
      @uriBase = uriBase
    end

    # Adds a URI and key pair that is associated with the given key pressed
    # by the user.  The full URI is the one set by setURIBase followed
    # by this uri.
    def addURI(key, uri)
      @entries += [PhoneImageMenuEntry.new(key, uri)]
    end

    # Sets the image based on an externally generated GD image.  Image must
    # be 40x144 in size and should be created using PhoneGDImage.
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

    # Create XML text output.
    def render
      title = escape(@title)
      out = "<AastraIPPhoneImageMenu"
      out += " destroyOnExit=\"yes\"" if @destroyOnExit == "yes"
      if not @cancelAction.nil? then
        cancelAction = escape(@cancelAction)
        out += " cancelAction=\"#{cancelAction}\""
      end
      out += " Beep=\"yes\"" if @beep == "yes"
      out += " LockIn=\"yes\"" if @locking == "yes"
      out += " Timeout=\"#{@timeout}\"" if @timeout != 0
      out += ">\n"
      out += "<Image"
      out += " verticalAlign=\"#{@verticalAlign}\"" if not @verticalAlign.nil?
      out += " horizontalAlign=\"#{@horizontalAlign}\"" if not @horizontalAlign.nil?
      out += " height=\"#{@height}\"" if not @height.nil?
      out += " width=\"#{@width}\"" if not @width.nil?
      out += ">#{@image}</Image>\n"
      out += "<URIList"
      out += " base=\"#{escape(@uriBase)}\"" if not @uriBase.nil?
      out += ">\n"
      @entries.each { |entry| out += entry.render }
      out += "</URIList>\n"
      @softkeys.each { |softkey| out += softkey.render }
      iconList = 0
      @icons.each do |icon|
        if iconList == 0
          out += "<IconList>\n"
          iconList = 1
        end
        out += icon.render
      end
      out += "</IconList>\n" if iconList != 0
      out += "</AastraIPPhoneImageMenu>\n"
      return out
    end
  end
end
