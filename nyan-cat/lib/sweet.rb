class Sweet
  attr_accessor :x, :y, :width, :height

  def initialize(window)
    @sprite = Gosu::Image.new(window, 'images/candy.png')
    @width = @sprite.width
    @height = @sprite.height
    reset(window)
  end

  def draw
    @sprite.draw(@x, @y, 1)
  end

  # resetting the sweet will move it to the right hand side of the screen 
  # the right hand side is the width. the maximum value x can take
  def reset(window)
    @y = Random.rand(window.height - @height)
    @x = window.width
  end

  def move
    @x = @x - 15
  end

end
