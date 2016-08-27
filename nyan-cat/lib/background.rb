class Background
  def initialize(window)
    @first_image = Gosu::Image.new(window, "images/bkg.jpg")
    @width = @first_image.width
    @second_image = Gosu::Image.new(window, "images/bkg.jpg")

    @first_x = 0
    @second_x = @first_x + @width
    @scroll_speed = 2
  end

  def draw
    @first_image.draw(@first_x, 0, 0)
    @second_image.draw(@second_x, 0, 0)
  end

  def scroll
    @first_x = @first_x - @scroll_speed
    @second_x = @second_x - @scroll_speed
    if (@first_x < -@width)
      @first_x = @width
      @second_x = 0
    elsif (@second_x < -@width)
      @second_x = @width
      @first_x = 0
    end
  end
end

