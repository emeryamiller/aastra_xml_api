require 'GD'

################################################################################
# Aastra XML API Classes - Aastra XML API Classes - PhoneGDImage
# Copyright Aastra Telecom 2008
#
# Ruby adaptation by Carlton O'Riley
#
# Firmware 2.2.0 or better
#
# PhoneGDImage for PhoneImageScreen and PhoneImageScreen.
#
# ruby needs ruby-gd gem installed
# ------------------------------
#
# Public methods
#
#	drawttftext(fontsize,angle,x,y,text,colorIndex,fontfile)
#	Writes text to the image using TrueType fonts
#	fontsize	The font size. Depending on your version of GD, this should be specified as the pixel
#			size (GD1) or point size (GD2)
#	angle		The angle in degrees, with 0 degrees being left-to-right reading text. Higher values
#			represent a counter-clockwise rotation. For example, a value of 90 would result in
#			bottom-to-top reading text.
#	x,y		The coordinates given by x and y will define the basepoint of the first character
#			(roughly the lower-left corner of the character).
#	colorIndex	0=White	1=Black
#	fontfile	Location and name of the ttf file to use
#
#	drawtext(fontsize,x,y,text,colorIndex)
#	Writes text to the image using built-in font
#	fontsize	The font size. From 1 to 5
#	x,y		The coordinates given by x and y will define the basepoint of the first character
#			(roughly the lower-left corner of the character).
#	colorIndex	0=White	1=Black
#
#	rectangle(x1,y1,x2,y2,colorIndex,filled)
#	Creates a rectangle starting at the specified coordinates.
#	x1,y1		Upper left x,y coordinate. 0,0 is the top left corner of the image.
#	x2,y2		Bottom right x,y coordinate
#	colorIndex	0=White	1=Black
#	filled		Boolean, optional (default if False)
#
#	ellipse(cx,cy,width,height,colorIndex,filled)
#	Draws an ellipse centered at the specified coordinates.
#	cx,cy		x-coordinate and y-coordinate of the center
#	width		the ellipse width
#	height		the ellipse height
#	colorIndex	0=White	1=Black
#	filled		Boolean, optional (default if False)
#
#	line(x1,y1,x2,y2,colorIndex)
#	Draws a line
#	x1,y1		x,y coordinates for the first point
#	x2,y2		x,y coordinates for the second point
#	colorIndex	0=White	1=Black
#
#	setGDImage(image)
#	Imports an externally generated GD image
#	image		GD image to import
#
#	getGDImage()
#	Exports the current GD image
#
#	setFontPath(fontpath)
#	Set directory path for the fonts to use
#	fontpath	Directory for the ttf fonts
#	Default value
#		Windows based platform		C:\Windows\Fonts
#		Linux based platform			../fonts
#   Mac OS X based platform   ../fonts
#   Rails based platform      RAILS_ROOT/fonts
#
# Example 1
#	require 'PhoneGDImage.rb'
#	phoneImageGD = PhoneGDImage.new
#	time = Time.now.strftime("%H:%M")
#	phoneImageGD.drawttftext(30, 0, 10, 39, time, 1,'Ni7seg.ttf')
#
# Example 2
#	require 'PhoneGDImage.rb'
#	phoneImageGD = PhoneGDImage.new
#	utf8text = "&#19996;&#19997;&#19998;&#19999;&#20024;"
#	phoneImageGD.drawttftext(20, 0, 5, 35, utf8text, 1, 'arialuni.ttf')
#
################################################################################

module AastraXmlApi
  class PhoneGDImage
    @img
    @white
    @black
    @blackNoAntiAliasing
    @font
    @fontpath

    # Creates a new GD image of size 144x40 (maximum allowed on phone). Also
    # creates black and white colors to be used and sets default font path
    # based on whether this is running under rails or a specific
    # operating system.
    def initialize
      # create image
      @img = GD::Image.new(144, 40)

      # define black and white
      @white = @img.colorAllocate(255, 255, 255)
      @black = @img.colorAllocate(0, 0, 0)

      # black and white only so disable anti-aliasing
      @black *= -1
      @white *= -1

      # define a default font path
      if defined?(RAILS_ROOT) then
        @fontpath = "#{RAILS_ROOT}/fonts"
      else
        os = RUBY_PLATFORM.downcase
        @fontpath = "C:\\Windows\\Fonts" if not os.scan(/win/).nil?
        @fontpath = "../fonts" if not os.scan(/linux$/).nil?
        @fontpath = "../fonts" if not os.scan(/darwin\d+\.\d+$/).nil?
      end
      ENV['GDFONTPATH'] = @fontpath
    end

    # Set font path for GD.
    def setFontPath(fontpath)
      @fontpath = fontpath
      ENV['GDFONTPATH'] = @fontpath
    end

    # Draw text on the image using a specific true type font.
    # See GD documentation for parameters.
    def drawttftext(size, angle, x, y, text, colorIndex, font)
      @img.stringTTF(getColor(colorIndex), font, size, angle, x, y, text)
    end

    # Draw text on the image.
    def drawtext(size, x, y, text, colorIndex)
      @img.string(size, x, y, text, getColor(colorIndex))
    end

    # Set the image from an externally created GD image.
    def setGDImage(image)
      @img = image
    end

    # Get the GD image created.
    def getGDImage
      return @img
    end

    # Draw a rectangle on the image. Rectangle will be unfilled by default.
    def rectangle(x1, y1, x2, y2, colorIndex, filled=false)
      if filled then
        @img.filledRectangle(x1, y1, x2, y2, getColor(colorIndex))
      else
        @img.rectangle(x1, y1, x2, y2, getColor(colorIndex))
      end
    end

    # Draw an ellipse on the image. Ellipse will be unfilled by default.
    def ellipse(cx, cy, width, height, colorIndex, filled=false)
      if filled then
        @img.filledEllipse(cx, cy, width, height, 0, 360, getColor(colorIndex))
      else
        @img.ellipse(cx, cy, width, height, 0, 360, getColor(colorIndex))
      end
    end

    # Draw a line on the image.  Line will be solid by default.
    def line(x1, y1, x2, y2, colorIndex, dashed=false)
      if dashed then
        @img.dashedLine(x1, y2, x2, y2, getColor(colorIndex))
      else
        @img.line(x1, y2, x2, y2, getColor(colorIndex))
      end
    end

    # Get the GD color element based on an index.
    # 0:: white
    # 1:: black
    def getColor(index)
      return @white if index == 0
      return @black
    end
  end
end
