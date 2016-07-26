require "gosu"

class WackARuby < Gosu::Window

  def initialize(width, height)
    super(width, height)
    self.caption = "Wack A Ruby!"

    @ruby  = Gosu::Image.new("ruby.png")
    @dude  = Gosu::Image.new("dude.png")

    @x_offset, @y_offset, @width, @height  = 150, 150, 150, 150
    @velocity_x, @velocity_y = 4, 4
  end

  def draw
    @ruby.draw(@x_offset - @width / 2, @y_offset - @height / 2, 1)
    @dude.draw(150, 150, 1)
  end

  def update
    @x_offset += @velocity_x
    @y_offset += @velocity_y
    @velocity_x *= -1 if @x_offset + (@width / 4) > 800  || @x_offset - (@width / 4) < 0
    @velocity_y *= -1 if @y_offset + (@height / 4) > 600 || @y_offset - (@height / 4) < 0
  end
end

window = WackARuby.new(800, 600)
window.show
