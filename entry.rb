require 'plist'
require 'RMagick'

class Entry
  attr_reader :source, :image

  def self.from_path(path_to_doentry, path_to_photo, source = nil)
    return Entry.new Plist::parse_xml(path_to_doentry), path_to_photo, source
  end

  def initialize(plist, path_to_photo, source = nil)
    @plist = plist
    @path_to_photo = path_to_photo
    @source = source unless source == "default"
  end

  def id
    @plist['UUID']
  end

  def text
    @plist['Entry Text']
  end

  def date
    @plist['Creation Date']
  end

  def date_central
    date + Rational(-6,24)
  end

  def tags
    if @plist['Tags']
      return Array.new @plist['Tags']
    end
    []
  end

  def has_photo
    File.exist? @path_to_photo
  end

  def photo_content_type
    'image/jpeg'
  end

  def image
    @image ||= Magick::Image.read(@path_to_photo).first
  end

  def photo_data
    image = self.image
    image.resize_to_fit! 1024, 1024
    image.to_blob
  end

  def weather?
    !@plist["Weather"].nil?
  end

  def temperature
    return nil unless weather?
    @plist["Weather"]["Fahrenheit"]
  end

  def weather_description
    return nil unless weather?
    @plist["Weather"]["Description"]
  end

  def location?
    @plist["Location"] && !@plist["Location"]["Place Name"].nil?
  end

  def location
    [
      @plist["Location"]["Place Name"],
      @plist["Location"]["Locality"],
      @plist["Location"]["Administrative Area"]
    ].reject { |l| l == "" }.join(", ")
  end

  def starred?
    @plist["Starred"]
  end
end
