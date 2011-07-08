class OriginalImage

  def initialize(picture)
    @data	    = picture.read
    @raw	    = ''
  end

  def raw=(raw)
    @raw = raw
  end

  def raw
    @raw
  end

  def data
    @data
  end

  def test_and_prepare?
    begin
      @raw = Magick::Image.from_blob(@data).first
    rescue
      return false
    else
      if /png|jpg|jpeg|gif/i =~ @raw.format
	return true
      else
	return false
      end
    end
  end

end

