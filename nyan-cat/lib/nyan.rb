class NyanCat
  def initialize(window)
    # load the image and split it up into six sprites
    # for animation, specifying its width and height
    # and declaring it non-tileable
    @sprites = Gosu::Image::load_tiles(window,
                                       "images/cat.png",
                                       (847.to_f/6).ceil, 87, false)
                                       # 847/6

    # set initial coordinates, extract widht and height
    @x = 10
    @y = 200
    @width = @sprites.first.width
    @height = @sprites.first.height
  end

  def draw
    sprite = @sprites[Gosu::milliseconds / 75 % @sprites.size]
    sprite.draw(@x, @y, 1)
  end

  # each time the Window calls update and the key is being pressed
  # the cat’s y coordinate will go up or down by 5, so that the next
  # time the window is drawn the cat will appear to have moved 5 pixels
  def move_up
    @y = @y - 5
  end

  def move_down
    @y = @y + 5
  end

  def bumped_into?(object)
    # calculate the values for the top, bottom, left, right edges 
    # of both the cat and the object it bumps into
    self_top = @y
    self_bottom = @y + @height
    self_left = @x
    self_right = @x + @width

    object_top = object.y
    object_bottom = object.y + object.height
    object_left = object.x
    object_right = object.x + object.width

    # figure out if objects collide
    if self_top > object_bottom
      false
    elsif self_bottom < object_top
      false
    elsif self_left > object_right
      false
    elsif self_right < object_left
      false
    else
      true
    end
  end
end
